import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_smart/get_smart.dart';

class GetTextField extends StatefulWidget {
  const GetTextField({
    this.text,
    this.label,
    this.hint,
    this.error,
    this.helper,
    this.hintIcon,
    this.prefix,
    this.suffix,
    this.autovalidateMode,
    this.keyboardType,
    this.inputFilters,
    this.textInputAction,
    this.focusNode,
    this.controller,
    this.onTap,
    this.onSubmitted,
    this.onSaved,
    this.onChanged,
    this.validator,
    this.readOnly,
    this.tapOnly = true,
    this.validateLength,
    this.validateEmpty = true,
    this.showCounter,
    this.isDense,
    this.filled,
    this.obscureText,
    this.enableSuggestions,
    this.maxLength,
    this.minLines,
    this.maxLines = 1,
    this.margin,
    this.padding,
    this.background,
    this.textCapitalization = TextCapitalization.none,
    this.style,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.autofocus = false,
    this.expands = false,
    this.toolbarOptions,
    this.showCursor,
    this.obscuringCharacter = "•",
    this.smartDashesType,
    this.smartQuotesType,
    this.maxLengthEnforcement = true,
    this.onEditingComplete,
    this.enabled = true,
    this.cursorWidth = 2.0,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorColor,
    this.keyboardBrightness,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.enableInteractiveSelection = true,
    this.selectionControls,
    this.buildCounter,
    this.scrollPhysics,
    this.autofillHints,
    this.icon,
    this.labelStyle,
    this.helperStyle,
    this.helperMaxLines,
    this.hintStyle,
    this.hintMaxLines,
    this.errorStyle,
    this.errorMaxLines,
    this.floatingLabelBehavior = FloatingLabelBehavior.auto,
    this.isCollapsed = false,
    this.contentPadding,
    this.prefixIcon,
    this.prefixIconConstraints,
    this.prefixText,
    this.prefixStyle,
    this.suffixIcon,
    this.suffixText,
    this.suffixStyle,
    this.suffixIconConstraints,
    this.counter,
    this.counterText,
    this.counterStyle,
    this.fillColor,
    this.focusColor,
    this.hoverColor,
    this.errorBorder,
    this.focusedBorder,
    this.focusedErrorBorder,
    this.disabledBorder,
    this.enabledBorder,
    this.border,
    this.semanticCounterText,
    this.alignLabelWithHint,
    Key key,
  }) : super(key: key);

  final String text;
  final String label;
  final String hint;
  final String error;
  final String helper;
  final Widget hintIcon;
  final Widget prefix;
  final Widget suffix;
  final TextInputType keyboardType;
  final AutovalidateMode autovalidateMode;
  final List<TextInputFormatter> inputFilters;
  final TextInputAction textInputAction;
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function onTap;
  final void Function(String v) onSubmitted;
  final void Function(String v) onSaved;
  final void Function(String v) onChanged;
  final String Function(String v) validator;
  final bool readOnly;
  final bool tapOnly;
  final bool validateLength;
  final bool validateEmpty;
  final bool showCounter;
  final bool isDense;
  final bool filled;
  final bool obscureText;
  final bool enableSuggestions;
  final int maxLength;
  final int minLines;
  final int maxLines;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final Color background;
  final TextCapitalization textCapitalization;
  final TextStyle style;
  final TextAlign textAlign;
  final TextAlignVertical textAlignVertical;
  final bool autofocus;
  final bool expands;
  final ToolbarOptions toolbarOptions;
  final bool showCursor;
  final String obscuringCharacter;
  final SmartDashesType smartDashesType;
  final SmartQuotesType smartQuotesType;
  final bool maxLengthEnforcement;
  final VoidCallback onEditingComplete;
  final bool enabled;
  final double cursorWidth;
  final double cursorHeight;
  final Radius cursorRadius;
  final Color cursorColor;
  final Brightness keyboardBrightness;
  final EdgeInsets scrollPadding;
  final bool enableInteractiveSelection;
  final TextSelectionControls selectionControls;
  final InputCounterWidgetBuilder buildCounter;
  final ScrollPhysics scrollPhysics;
  final Iterable<String> autofillHints;
  final Widget icon;
  final TextStyle labelStyle;
  final TextStyle helperStyle;
  final int helperMaxLines;
  final TextStyle hintStyle;
  final int hintMaxLines;
  final TextStyle errorStyle;
  final int errorMaxLines;
  final FloatingLabelBehavior floatingLabelBehavior;
  final bool isCollapsed;
  final EdgeInsetsGeometry contentPadding;
  final Widget prefixIcon;
  final BoxConstraints prefixIconConstraints;
  final String prefixText;
  final TextStyle prefixStyle;
  final Widget suffixIcon;
  final String suffixText;
  final TextStyle suffixStyle;
  final BoxConstraints suffixIconConstraints;
  final Widget counter;
  final String counterText;
  final TextStyle counterStyle;
  final Color fillColor;
  final Color focusColor;
  final Color hoverColor;
  final InputBorder errorBorder;
  final InputBorder focusedBorder;
  final InputBorder focusedErrorBorder;
  final InputBorder disabledBorder;
  final InputBorder enabledBorder;
  final InputBorder border;
  final String semanticCounterText;
  final bool alignLabelWithHint;

  @override
  _GetTextFieldState createState() => _GetTextFieldState();
}

class _GetTextFieldState extends State<GetTextField> {
  String get _hint =>
      widget.hint ?? widget.label?.lowercase ?? GetText.value().lowercase;

  String Function(String v) get _validator =>
      widget.validator != null ? widget.validator : (v) => null;

  bool get _readOnly =>
      widget.readOnly == true ||
      ((widget.tapOnly ?? true) && widget.onTap != null);

  bool get _obscureText => widget.obscureText == true;

  String _validate(String v) =>
      _validator(v) ??
      (widget.validateEmpty == true && v.isEmpty
          ? GetText.please_enter([_hint])
          : widget.validateLength == true && v.length != widget.maxLength
              ? GetText.invalid([_hint])
              : null);

  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController(text: widget.text);
  }

  @override
  Widget build(BuildContext context) => Container(
        padding: widget.padding ?? EdgeInsets.zero,
        margin: widget.margin ?? EdgeInsets.zero,
        color: widget.background ?? Colors.transparent,
        child: TextFormField(
          focusNode: widget.focusNode,
          controller: _controller,
          autovalidateMode: widget.autovalidateMode ??
              ((widget.validator != null
                      ? _validator(_controller.text) != null
                      : _controller.text.isNotEmpty)
                  ? AutovalidateMode.always
                  : AutovalidateMode.onUserInteraction),
          readOnly: _readOnly,
          decoration: InputDecoration(
            prefix: widget.prefix != null || widget.hintIcon != null
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.prefix != null) widget.prefix,
                      if (widget.hintIcon != null)
                        Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: IconTheme(
                            data: context.theme.iconTheme.copyWith(
                              size: 16,
                              color: context.theme.hintColor,
                            ),
                            child: widget.hintIcon,
                          ),
                        ),
                    ],
                  )
                : null,
            isDense: widget.isDense,
            filled: widget.filled,
            labelText: widget.label,
            hintText: widget.hint,
            helperText: widget.helper ?? " ",
            helperMaxLines: widget.helperMaxLines ?? 10,
            errorMaxLines: widget.errorMaxLines ?? 10,
            errorText: widget.error,
            suffix: widget.suffix,
            counterText: widget.showCounter ?? true ? widget.counterText : "",
            icon: widget.icon,
            labelStyle: widget.labelStyle,
            helperStyle: widget.helperStyle,
            hintStyle: widget.hintStyle,
            hintMaxLines: widget.hintMaxLines,
            errorStyle: widget.errorStyle,
            floatingLabelBehavior:
                widget.floatingLabelBehavior ?? FloatingLabelBehavior.auto,
            isCollapsed: widget.isCollapsed ?? false,
            contentPadding: widget.contentPadding,
            prefixIcon: widget.prefixIcon,
            prefixIconConstraints: widget.prefixIconConstraints,
            prefixText: widget.prefixText,
            prefixStyle: widget.prefixStyle,
            suffixIcon: widget.suffixIcon,
            suffixText: widget.suffixText,
            suffixStyle: widget.suffixStyle,
            suffixIconConstraints: widget.suffixIconConstraints,
            counter: widget.showCounter ?? true ? widget.counter : null,
            counterStyle: widget.counterStyle,
            fillColor: widget.fillColor,
            focusColor: widget.focusColor,
            hoverColor: widget.hoverColor,
            errorBorder: widget.errorBorder,
            focusedBorder: widget.focusedBorder,
            focusedErrorBorder: widget.focusedErrorBorder,
            disabledBorder: widget.disabledBorder,
            enabledBorder: widget.enabledBorder,
            border: widget.border,
            semanticCounterText: widget.semanticCounterText,
            alignLabelWithHint: widget.alignLabelWithHint,
          ),
          keyboardType: widget.keyboardType,
          obscureText: _obscureText,
          enableSuggestions: widget.enableSuggestions ?? !_obscureText,
          autocorrect: widget.enableSuggestions ?? !_obscureText,
          textInputAction: widget.textInputAction,
          maxLength: widget.maxLength,
          inputFormatters: widget.inputFilters,
          minLines: widget.minLines,
          maxLines: widget.maxLines,
          onSaved: widget.onSaved,
          validator: _validate,
          onTap: widget.readOnly == true ? null : widget.onTap,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          textCapitalization:
              widget.textCapitalization ?? TextCapitalization.none,
          style: widget.style,
          textAlign: widget.textAlign ?? TextAlign.start,
          autofocus: widget.autofocus ?? false,
          expands: widget.expands ?? false,
          toolbarOptions: widget.toolbarOptions,
          showCursor: widget.showCursor,
          obscuringCharacter: widget.obscuringCharacter ?? "•",
          smartDashesType: widget.smartDashesType,
          smartQuotesType: widget.smartQuotesType,
          //maxLengthEnforced: maxLengthEnforcement ?? true,
          onEditingComplete: widget.onEditingComplete,
          enabled: widget.enabled ?? true,
          cursorWidth: widget.cursorWidth ?? 2.0,
          cursorHeight: widget.cursorHeight,
          cursorRadius: widget.cursorRadius,
          cursorColor: widget.cursorColor,
          keyboardAppearance: widget.keyboardBrightness,
          scrollPadding: widget.scrollPadding ?? const EdgeInsets.all(20.0),
          enableInteractiveSelection: widget.enableInteractiveSelection ?? true,
          selectionControls: widget.selectionControls,
          buildCounter: widget.buildCounter,
          scrollPhysics: widget.scrollPhysics,
          autofillHints: widget.autofillHints,
        ),
      );
}
