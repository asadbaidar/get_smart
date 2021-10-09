import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_smart/get_smart.dart';
import 'package:get_smart/src/widgets/text_field.dart';

typedef GetFilterItemBuilder<T> = Widget Function(
    BuildContext context, T data, VoidCallback onTap);

typedef Filter<T> = bool Function(T data, String query);

typedef ItemSubmitted<T> = void Function(T data);

typedef StringCallback = void Function(String data);

/// A wrapper of [GetTextField] with filterable suggestion features.
class GetFilterableTextField<T extends Comparable> extends StatefulWidget {
  /// Callback to filter item: return true or false depending on input text
  final Filter<T>? itemFilter;

  /// Callback to sort items in the form (a of type <T>, b of type <T>)
  final Comparator<T>? itemSorter;

  /// Callback on input text changed, this is a string
  final StringCallback? textChanged;

  /// Callback on input text submitted, this is also a string
  final StringCallback? textSubmitted;
  final ValueSetter<bool>? onFocusChanged;

  /// Callback on item selected, this is the item selected of type <T>
  final ItemSubmitted<T?> itemSubmitted;

  /// Callback to build each item, return a Widget
  final GetFilterItemBuilder<T>? itemBuilder;

  /// The amount of suggestions to show, larger values will go in ListView
  final int itemCount;

  /// The amount of suggestions to be visible at a time in ListView
  final int visibleCount;

  /// Item height for suggestions list
  final double itemHeight;

  /// Call textSubmitted on suggestion tap, itemSubmitted will be called no matter what
  final bool submitOnItemTap;

  /// Clear autoCompleteTextField on submit
  final bool clearOnSubmit;

  /// Show all suggestions without filter when focused
  final bool showAllOnFocus;

  /// Disable query and filtering for suggestions and show all items
  final bool disableFiltering;

  /// Don't accept simple text, only suggestion item
  final bool onlyAcceptItem;

  final List<TextInputFormatter>? inputFormatters;
  final int minLength;
  final bool readOnly;
  final bool validateEmpty;

  final TextStyle? style;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final TextCapitalization textCapitalization;
  final TextEditingController? controller;
  final dynamic initialValue;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;

  /// Suggestions that will be displayed
  final List<T>? items;
  final String? label;
  final String? helper;
  final String? error;

  const GetFilterableTextField({
    required GlobalKey<GetFilterableTextFieldState<T>> key,
    required this.itemSubmitted,
    this.items,
    this.itemBuilder,
    this.itemSorter,
    this.itemFilter,
    this.inputFormatters,
    this.style,
    this.label,
    this.helper,
    this.error,
    this.textChanged,
    this.textSubmitted,
    this.onFocusChanged,
    this.keyboardType = TextInputType.text,
    this.itemCount = 5,
    this.visibleCount = 5,
    this.itemHeight = 58,
    this.submitOnItemTap = true,
    this.clearOnSubmit = false,
    this.showAllOnFocus = false,
    this.disableFiltering = false,
    this.onlyAcceptItem = true,
    this.textInputAction = TextInputAction.done,
    this.textCapitalization = TextCapitalization.sentences,
    this.minLength = 0,
    this.readOnly = false,
    this.validateEmpty = false,
    this.controller,
    this.initialValue,
    this.focusNode,
    this.nextFocusNode,
  }) : super(key: key);

  void _itemSubmitted(T? data) => itemSubmitted(data);

  Widget _itemBuilder(BuildContext context, T data, VoidCallback onTap) =>
      itemBuilder?.call(context, data, onTap) ??
      GetTile.center500(
        title: data.toString(),
        onTap: onTap,
      );

  int _itemSorter(T a, T b) => itemSorter?.call(a, b) ?? a.compareTo(b);

  bool _itemFilter(T data, String query) =>
      disableFiltering ||
      (itemFilter?.call(data, query) ??
          data.toString().containsIgnoreCase(query));

  @override
  State<StatefulWidget> createState() => GetFilterableTextFieldState<T>();
}

class GetFilterableTextFieldState<T extends Comparable>
    extends State<GetFilterableTextField> {
  final LayerLink _layerLink = LayerLink();

  void itemSubmitted(T? data) => widget._itemSubmitted(data);

  Widget itemBuilder(BuildContext context, T data, VoidCallback onTap) =>
      widget._itemBuilder(context, data, onTap);

  int itemSorter(T a, T b) => widget._itemSorter(a, b);

  bool itemFilter(T data, String query) => widget._itemFilter(data, query);

  List<T>? _items;

  List<T> get items => _items ?? widget.items?.cast() ?? [];

  String? _error;

  String? get error => _error ?? widget.error;

  String? get helper => widget.helper;

  String? get label => widget.label;

  StringCallback? get textChanged => widget.textChanged;

  StringCallback? get textSubmitted => widget.textSubmitted;

  ValueSetter<bool>? get onFocusChanged => widget.onFocusChanged;

  int get itemCount => widget.itemCount;

  int get visibleCount => widget.visibleCount;

  double get itemHeight => widget.itemHeight;

  bool get submitOnItemTap => widget.submitOnItemTap;

  bool get clearOnSubmit => widget.clearOnSubmit;

  bool get showAllOnFocus => widget.showAllOnFocus;

  bool get disableFiltering => widget.disableFiltering;

  bool get onlyAcceptItem => widget.onlyAcceptItem;

  int get minLength => widget.minLength;

  bool get readOnly => widget.readOnly;

  bool get validateEmpty => widget.validateEmpty;

  List<TextInputFormatter>? get inputFormatters => widget.inputFormatters;

  TextCapitalization get textCapitalization => widget.textCapitalization;

  TextStyle? get style => widget.style;

  TextInputType get keyboardType => widget.keyboardType;

  TextInputAction get textInputAction => widget.textInputAction;

  TextEditingController get controller =>
      widget.controller ?? _controller ?? TextEditingController();

  String? get initialValue => widget.initialValue?.toString();

  FocusNode get focusNode => widget.focusNode ?? _focusNode ?? FocusNode();

  FocusNode? get nextFocusNode => widget.nextFocusNode;

  TextEditingController? _controller;
  FocusNode? _focusNode;
  OverlayEntry? itemsOverlayEntry;
  List<T> filteredItems = [];
  String currentText = "";

  @override
  void initState() {
    super.initState();
    $debugPrint("init");
    if (widget.focusNode == null) _focusNode = FocusNode();
    if (widget.controller == null) _controller = TextEditingController();
    if (controller.text.isEmpty && initialValue?.notEmpty != null) {
      controller.text = initialValue!;
    }
    currentText = controller.text;
  }

  void focusListener() {
    $debugPrint(focusNode.hasFocus, "Focus");
    if (onFocusChanged != null) {
      onFocusChanged!(focusNode.hasFocus);
    }
    if (!focusNode.hasFocus) {
      triggerItemSubmitted();
      setError(null);
      currentText = "";
      filteredItems = [];
      updateOverlay();
    } else if (currentText.isNotEmpty) {
      updateOverlay(query: currentText, withoutFilter: showAllOnFocus);
    }
  }

  bool get isTextEmpty => controller.text.trim().isEmpty;

  void removeError({bool focus = false}) {
    if (error != null) setError(null, focus: focus);
  }

  void setError(String? errorText, {bool focus = false}) {
    $debugPrint(errorText, "setError");
    setState(() => _error = errorText);
    if (focus) focusNode.requestFocus();
  }

  void triggerSubmitted([submittedText]) {
    if (textSubmitted != null) {
      submittedText == null
          ? textSubmitted!(currentText)
          : textSubmitted!(submittedText);
    }

    triggerItemSubmitted();

    if (clearOnSubmit) {
      clear();
    }

    if (textInputAction == TextInputAction.next) {
      focusNode.forward(to: nextFocusNode);
    }
  }

  void triggerItemSubmitted() {
    if (!readOnly &&
        onlyAcceptItem &&
        !filteredItems.map((it) => it.toString()).contains(controller.text)) {
      var item = filteredItems.firstOrNull;
      controller.text = item?.toString() ?? "";
      if (item == null) {
        clear();
      } else {
        removeError();
      }
      itemSubmitted(item);
    }
  }

  void clear() {
    controller.clear();
    currentText = "";
    updateOverlay();
  }

  void clearItems() {
    items.clear();
    updateOverlay(query: currentText);
  }

  void addItem(T item) {
    items.add(item);
    updateOverlay(query: currentText);
  }

  void removeItem(T item) {
    if (items.remove(item)) updateOverlay(query: currentText);
  }

  void updateItems(List<T> items) {
    _items = items;
    updateOverlay(query: currentText);
  }

  Future<void> updateOverlay(
      {String? query, bool withoutFilter = false}) async {
    if (!mounted) return;
    $debugPrint(
        "NoFilter $withoutFilter Focus ${focusNode.hasFocus}", "updateOverlay");
    filteredItems = withoutFilter == true
        ? items
        : await getItems(items, itemSorter, itemFilter, itemCount, query);
    if (itemsOverlayEntry == null) {
      final Size textFieldSize = (context.findRenderObject() as RenderBox).size;
      final width = textFieldSize.width;
      final height = textFieldSize.height;
      itemsOverlayEntry = OverlayEntry(builder: (context) {
        $debugPrint("Focus ${focusNode.hasFocus}", "OverlayEntry");
        if (!focusNode.hasFocus) clearOverlay();
        final listHeight = filteredItems.length > visibleCount
            ? (visibleCount * itemHeight).toDouble() + 6
            : null;
        return Positioned(
          width: width,
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: Offset(0.0, (height - 24).abs()),
            child: SizedBox(
              width: width,
              height: listHeight,
              child: Card(
                child: Scrollbar(
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: listHeight == null,
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      return Row(children: [
                        Expanded(
                          child: itemBuilder(
                            context,
                            item,
                            () => setState(() {
                              if (submitOnItemTap) {
                                String newText = item.toString();
                                controller.text = newText;
                                itemSubmitted(item);
                                focusNode.unfocus();
                                clearOverlay();
                                if (clearOnSubmit) clear();
                              } else {
                                String newText = item.toString();
                                controller.text = newText;
                                textChanged!(newText);
                              }
                              removeError();
                            }),
                          ),
                        )
                      ]);
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      });
      Overlay.of(context)!.insert(itemsOverlayEntry!);
    }

    itemsOverlayEntry!.markNeedsBuild();
  }

  Future<List<T>> getItems(
    List<T> items,
    Comparator<T> sorter,
    Filter<T> filter,
    int maxAmount,
    String? query,
  ) =>
      scheduleTask(() {
        if (query == null || query.length < minLength) {
          return [];
        }
        items = items.where((item) => filter(item, query)).toList();
        items.sort(sorter);
        if (items.length > maxAmount) {
          items = items.sublist(0, maxAmount);
        }
        return items;
      });

  @override
  void deactivate() {
    $debugPrint("deactivate");
    clearOverlay();
    super.deactivate();
  }

  void clearOverlay() {
    itemsOverlayEntry?.remove();
    itemsOverlayEntry = null;
  }

  @override
  void dispose() {
    $debugPrint("dispose");
    focusNode.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    focusNode.removeListener(focusListener);
    focusNode.addListener(focusListener);
    return CompositedTransformTarget(
      link: _layerLink,
      child: GetTextField(
        label: label,
        helper: helper,
        error: error,
        style: style,
        validateEmpty: validateEmpty,
        readOnly: readOnly,
        tapOnly: disableFiltering,
        inputFormatters: inputFormatters,
        textCapitalization: textCapitalization,
        keyboardType:
            showAllOnFocus ? TextInputType.visiblePassword : keyboardType,
        focusNode: focusNode,
        controller: controller,
        textInputAction: textInputAction,
        enableSuggestions: !showAllOnFocus,
        onChanged: (v) {
          currentText = v;
          $debugPrint("onChanged");
          updateOverlay(query: v);
          if (textChanged != null) textChanged!(v);
          removeError();
        },
        onTap: () => updateOverlay(
          query: currentText,
          withoutFilter: showAllOnFocus,
        ),
        onSubmitted: triggerSubmitted,
      ),
    );
  }
}

/*
              Padding(
                padding: const EdgeInsets.all(16),
                child: RawAutocomplete<Alphabet>(
                  optionsBuilder: (TextEditingValue textEditingValue) =>
                      dataSet.where((option) =>
                          option.containsIgnoreCase(textEditingValue.text)),
                  onSelected: (selection) =>
                      model.autocompleteSelection = selection,
                  fieldViewBuilder:
                      (context, controller, focusNode, onFieldSubmitted) {
                    return TextFormField(
                      controller: controller,
                      decoration: const InputDecoration(
                        hintText: 'This is a RawAutocomplete!',
                      ),
                      focusNode: focusNode,
                      onFieldSubmitted: (String value) {
                        onFieldSubmitted();
                      },
                      validator: (String? value) {
                        if (dataSet.firstWhereOrNull(
                                (option) => option.containsIgnoreCase(value)) ==
                            null) {
                          return 'Nothing selected.';
                        }
                        return null;
                      },
                    );
                  },
                  optionsViewBuilder: (context, onSelected, options) {
                    return Container(
                      margin: EdgeInsets.only(right: 16),
                      padding: EdgeInsets.only(right: 16),
                      alignment: Alignment.topLeft,
                      child: Card(
                        child: SizedBox(
                          height: 250.0,
                          child: ListView.builder(
                            padding: const EdgeInsets.all(0),
                            itemCount: options.length,
                            itemBuilder: (context, int index) {
                              final option = options.elementAt(index);
                              return GetTile.simple(
                                title: option.description,
                                onTap: () => onSelected(option),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
*/
