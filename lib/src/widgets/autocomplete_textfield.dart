import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef Widget AutoCompleteOverlayItemBuilder<T>(
    BuildContext context, T suggestion, Function onTap);

typedef bool Filter<T>(T suggestion, String query);

typedef InputEventCallback<T>(T data);

typedef StringCallback(String data);

class AutoCompleteTextField<T> extends StatefulWidget {
  final Filter<T> itemFilter;
  final Comparator<T> itemSorter;
  final StringCallback textChanged, textSubmitted;
  final ValueSetter<bool> onFocusChanged;
  final InputEventCallback<T> itemSubmitted;
  final AutoCompleteOverlayItemBuilder<T> itemBuilder;
  final int suggestionsAmount;
  final GlobalKey<AutoCompleteTextFieldState<T>> key;
  final bool submitOnSuggestionTap, clearOnSubmit, onlySubmitSuggestion;
  final List<TextInputFormatter> inputFormatters;
  final int minLength;
  final bool readOnly;

  final TextStyle style;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final TextCapitalization textCapitalization;
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode nextFocusNode;

  final List<T> suggestions;
  final InputDecoration decoration;

  AutoCompleteTextField({
    @required
        this.itemSubmitted, //Callback on item selected, this is the item selected of type <T>
    @required this.key, //GlobalKey used to enable addSuggestion etc
    @required this.suggestions, //Suggestions that will be displayed
    @required this.itemBuilder, //Callback to build each item, return a Widget
    @required
        this.itemSorter, //Callback to sort items in the form (a of type <T>, b of type <T>)
    @required
        this.itemFilter, //Callback to filter item: return true or false depending on input text
    this.inputFormatters,
    this.style,
    this.decoration: const InputDecoration(),
    this.textChanged, //Callback on input text changed, this is a string
    this.textSubmitted, //Callback on input text submitted, this is also a string
    this.onFocusChanged,
    this.keyboardType: TextInputType.text,
    this.suggestionsAmount:
        5, //The amount of suggestions to show, larger values may result in them going off screen
    this.submitOnSuggestionTap:
        true, //Call textSubmitted on suggestion tap, itemSubmitted will be called no matter what
    this.clearOnSubmit: false, //Clear autoCompleteTextField on submit
    this.onlySubmitSuggestion:
        true, // Don't accept simple text, only suggestion item
    this.textInputAction: TextInputAction.done,
    this.textCapitalization: TextCapitalization.sentences,
    this.minLength = 0,
    this.readOnly,
    TextEditingController controller,
    FocusNode focusNode,
    this.nextFocusNode,
  })  : this.focusNode = focusNode ?? FocusNode(),
        this.controller = controller ?? TextEditingController(),
        super(key: key);

  void clear() => key.currentState.clear();

  void addSuggestion(T suggestion) =>
      key.currentState.addSuggestion(suggestion);

  void removeSuggestion(T suggestion) =>
      key.currentState.removeSuggestion(suggestion);

  void updateSuggestions(List<T> suggestions) =>
      key.currentState.updateSuggestions(suggestions);

  void triggerSubmitted() => key.currentState.triggerSubmitted();

  @override
  State<StatefulWidget> createState() => AutoCompleteTextFieldState<T>(
        itemSubmitted: itemSubmitted,
        itemBuilder: itemBuilder,
        itemSorter: itemSorter,
        itemFilter: itemFilter,
      );
}

class AutoCompleteTextFieldState<T> extends State<AutoCompleteTextField> {
  final LayerLink _layerLink = LayerLink();

  InputEventCallback<T> itemSubmitted;
  AutoCompleteOverlayItemBuilder<T> itemBuilder;
  Comparator<T> itemSorter;
  Filter<T> itemFilter;

  AutoCompleteTextFieldState({
    this.itemSubmitted,
    this.itemBuilder,
    this.itemSorter,
    this.itemFilter,
  });

  List<T> _suggestions;

  List<T> get suggestions => _suggestions ?? widget.suggestions;

  InputDecoration _decoration;

  InputDecoration get decoration => _decoration ?? widget.decoration;

  StringCallback get textChanged => widget.textChanged;

  StringCallback get textSubmitted => widget.textSubmitted;

  ValueSetter<bool> get onFocusChanged => widget.onFocusChanged;

  int get suggestionsAmount => widget.suggestionsAmount;

  bool get submitOnSuggestionTap => widget.submitOnSuggestionTap;

  bool get clearOnSubmit => widget.clearOnSubmit;

  bool get onlySubmitSuggestion => widget.onlySubmitSuggestion;

  int get minLength => widget.minLength;

  bool get readOnly => widget.readOnly;

  List<TextInputFormatter> get inputFormatters => widget.inputFormatters;

  TextCapitalization get textCapitalization => widget.textCapitalization;

  TextStyle get style => widget.style;

  TextInputType get keyboardType => widget.keyboardType;

  TextInputAction get textInputAction => widget.textInputAction;

  TextEditingController get controller => widget.controller;

  FocusNode get focusNode => widget.focusNode;

  FocusNode get nextFocusNode => widget.nextFocusNode;

  OverlayEntry listSuggestionsEntry;
  List<T> filteredSuggestions = [];
  String currentText = "";

  void initState() {
    super.initState();
    if (this.controller != null && this.controller.text != null) {
      currentText = this.controller.text;
    }
  }

  void focusListener() {
    if (onFocusChanged != null) {
      onFocusChanged(focusNode.hasFocus);
    }

    if (!focusNode.hasFocus) {
      triggerSuggestionSubmitted();
      setError(null);
      currentText = "";
      filteredSuggestions = [];
      updateOverlay();
    } else if (!(currentText == "" || currentText == null)) {
      updateOverlay(currentText);
    }
  }

  bool get isTextEmpty {
    final text = controller?.text?.trim();
    return text == null || text.isEmpty;
  }

  void removeError({bool focus: false}) {
    if (decoration.errorText != null) {
      setError(null, focus: focus);
    }
  }

  void setError(String errorText, {bool focus: false}) {
    setState(() {
      _decoration = InputDecoration(
        errorText: errorText,
        labelText: decoration.labelText,
        helperText: decoration.helperText,
      );
    });
    if (focus) focusNode?.requestFocus();
  }

  void triggerSubmitted({submittedText}) {
    if (textSubmitted != null)
      submittedText == null
          ? textSubmitted(currentText)
          : textSubmitted(submittedText);

    triggerSuggestionSubmitted();

    if (clearOnSubmit) {
      clear();
    }

    if (textInputAction == TextInputAction.next)
      focusNode?.forward(to: nextFocusNode);
  }

  void triggerSuggestionSubmitted() {
    if (!readOnly &&
        onlySubmitSuggestion &&
        !filteredSuggestions
            .map((it) => it.toString())
            .contains(controller.text)) {
      var item = filteredSuggestions?.takeFirst;
      controller.text = item?.toString();
      if (item == null)
        clear();
      else
        removeError();
      itemSubmitted(item);
    }
  }

  void clear() {
    controller.clear();
    currentText = "";
    updateOverlay();
  }

  void addSuggestion(T suggestion) {
    suggestions.add(suggestion);
    updateOverlay(currentText);
  }

  void removeSuggestion(T suggestion) {
    suggestions.contains(suggestion)
        ? suggestions.remove(suggestion)
        : throw "List does not contain suggestion and therefore cannot be removed";
    updateOverlay(currentText);
  }

  void updateSuggestions(List<T> suggestions) {
    this._suggestions = suggestions;
    updateOverlay(currentText);
  }

  void updateOverlay([String query]) {
    print("updateOverlay $listSuggestionsEntry");
    filteredSuggestions = getSuggestions(
        suggestions, itemSorter, itemFilter, suggestionsAmount, query);
    if (listSuggestionsEntry == null) {
      final Size textFieldSize = (context.findRenderObject() as RenderBox).size;
      final width = textFieldSize.width;
      final height = textFieldSize.height;
      listSuggestionsEntry = new OverlayEntry(builder: (context) {
        print("OverlayEntry $filteredSuggestions");
        return new Positioned(
            width: width,
            child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(0.0, (height - 24).abs()),
                child: new SizedBox(
                    width: width,
                    height: filteredSuggestions.length > 5
                        ? MediaQuery.of(context).size.height * 0.4
                        : null,
                    child: new Card(
                        child: Scrollbar(
                      child: SingleChildScrollView(
                        child: new Column(
                          children: filteredSuggestions.map((suggestion) {
                            return new Row(children: [
                              new Expanded(
                                  child: itemBuilder(context, suggestion, () {
                                setState(() {
                                  if (submitOnSuggestionTap) {
                                    String newText = suggestion.toString();
                                    controller.text = newText;
                                    focusNode.unfocus();
                                    itemSubmitted(suggestion);
                                    removeError();
                                    if (clearOnSubmit) {
                                      clear();
                                    }
                                  } else {
                                    String newText = suggestion.toString();
                                    controller.text = newText;
                                    textChanged(newText);
                                    removeError();
                                  }
                                });
                              }))
                            ]);
                          }).toList(),
                        ),
                      ),
                    )))));
      });
      Overlay.of(context).insert(listSuggestionsEntry);
    }

    listSuggestionsEntry.markNeedsBuild();
  }

  List<T> getSuggestions(List<T> suggestions, Comparator<T> sorter,
      Filter<T> filter, int maxAmount, String query) {
    if (null == query || query.length < minLength) {
      return [];
    }

    suggestions = suggestions.where((item) => filter(item, query)).toList();
    suggestions.sort(sorter);
    if (suggestions.length > maxAmount) {
      suggestions = suggestions.sublist(0, maxAmount);
    }
    return suggestions;
  }

  @override
  void dispose() {
    // if we created our own focus node and controller, dispose of them
    // otherwise, let the caller dispose of their own instances
    if (focusNode == null) {
      focusNode.dispose();
    }
    if (controller == null) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    focusNode.removeListener(focusListener);
    focusNode.addListener(focusListener);
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextField(
        readOnly: readOnly,
        inputFormatters: this.inputFormatters,
        textCapitalization: this.textCapitalization,
        decoration: this.decoration,
        style: this.style,
        keyboardType: this.keyboardType,
        focusNode: focusNode,
        controller: controller,
        textInputAction: this.textInputAction,
        onChanged: (newText) {
          currentText = newText;
          updateOverlay(newText);

          if (textChanged != null) {
            textChanged(newText);
          }
          removeError();
        },
        onTap: readOnly == true ? null : () => updateOverlay(currentText),
        onSubmitted: (submittedText) =>
            triggerSubmitted(submittedText: submittedText),
      ),
    );
  }
}

class SimpleAutoCompleteTextField extends AutoCompleteTextField<String> {
  final StringCallback textChanged, textSubmitted;
  final int minLength;
  final bool readOnly;
  final ValueSetter<bool> onFocusChanged;
  final TextEditingController controller;
  final FocusNode focusNode;

  SimpleAutoCompleteTextField({
    TextStyle style,
    InputDecoration decoration: const InputDecoration(),
    this.onFocusChanged,
    this.textChanged,
    this.textSubmitted,
    this.readOnly,
    this.minLength = 0,
    this.controller,
    this.focusNode,
    TextInputType keyboardType: TextInputType.text,
    @required GlobalKey<AutoCompleteTextFieldState<String>> key,
    @required List<String> suggestions,
    int suggestionsAmount: 5,
    bool submitOnSuggestionTap: true,
    bool clearOnSubmit: true,
    TextInputAction textInputAction: TextInputAction.done,
    TextCapitalization textCapitalization: TextCapitalization.sentences,
  }) : super(
          style: style,
          decoration: decoration,
          textChanged: textChanged,
          textSubmitted: textSubmitted,
          itemSubmitted: textSubmitted,
          keyboardType: keyboardType,
          key: key,
          suggestions: suggestions,
          itemBuilder: (context, item, onTap) => InkWell(
            onTap: onTap,
            child: new Padding(
              padding: EdgeInsets.all(8.0),
              child: new Text(item),
            ),
          ),
          itemSorter: (a, b) => a.compareTo(b),
          itemFilter: (item, query) =>
              item.toLowerCase().startsWith(query.toLowerCase()),
          suggestionsAmount: suggestionsAmount,
          submitOnSuggestionTap: submitOnSuggestionTap,
          clearOnSubmit: clearOnSubmit,
          textInputAction: textInputAction,
          textCapitalization: textCapitalization,
        );

  @override
  State<StatefulWidget> createState() => AutoCompleteTextFieldState<String>(
        itemSubmitted: itemSubmitted,
        itemBuilder: itemBuilder,
        itemSorter: itemSorter,
        itemFilter: itemFilter,
      );
}

extension _ListExt<E> on List<E> {
  E get takeFirst {
    Iterator<E> it = iterator;
    if (!it.moveNext()) {
      return null;
    }
    return it.current;
  }
}

extension _FocusNodeExt on FocusNode {
  void forward({FocusNode to}) {
    unfocus();
    to?.requestFocus();
  }
}
