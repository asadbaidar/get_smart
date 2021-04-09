import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_smart/get_smart.dart';

/// Build on top of TextFormField, extending its capabilities to get more out
/// of the box.
class GetTextField extends StatelessWidget {
  const GetTextField({
    this.initialText,
    this.controlledText,
    this.controller,
    this.autovalidateMode,
    this.keyboardType,
    this.inputFilters,
    this.textInputAction,
    this.focusNode,
    this.onTap,
    this.onSubmitted,
    this.onSaved,
    this.onChanged,
    this.validator,
    this.autoControlled = true,
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
    this.label,
    this.hint,
    this.error,
    this.helper,
    this.hintIcon,
    this.prefix,
    this.suffix,
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

  /// If provided, it disables any explicit [controller].
  final String initialText;

  /// Controlled by implicit controller and only effective if [initialText]
  /// and [controller] are not provided.
  final String controlledText;

  /// To make it effective, don't provide [initialText].
  final TextEditingController controller;

  final TextInputType keyboardType;
  final AutovalidateMode autovalidateMode;
  final List<TextInputFormatter> inputFilters;
  final TextInputAction textInputAction;
  final FocusNode focusNode;
  final Function onTap;
  final void Function(String v) onSubmitted;
  final void Function(String v) onSaved;
  final void Function(String v) onChanged;
  final String Function(String v) validator;
  final bool autoControlled;
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
  final String label;
  final String hint;
  final String error;
  final String helper;
  final Widget hintIcon;
  final Widget prefix;
  final Widget suffix;
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

  String get _hint => hint ?? label?.lowercase ?? GetText.value().lowercase;

  String Function(String v) get _validator =>
      validator != null ? validator : (v) => null;

  bool get _readOnly =>
      readOnly == true || ((tapOnly ?? true) && onTap != null);

  bool get _obscureText => obscureText == true;

  String _tryValidator(String v) {
    try {
      return _validator(v);
    } catch (_) {
      return null;
    }
  }

  String _validate(String v) =>
      _tryValidator(v) ??
      (validateEmpty == true && v.isEmpty
          ? GetText.please_enter([_hint])
          : validateLength == true && v.length != maxLength
              ? GetText.invalid([_hint])
              : null);

  AutovalidateMode get _autovalidateMode =>
      autovalidateMode ??
      ((validator != null ? _tryValidator(_text) != null : _text.isNotEmpty)
          ? AutovalidateMode.always
          : AutovalidateMode.onUserInteraction);

  TextEditingController get _controller => initialText != null
      ? null
      : controller ??
          (autoControlled ?? true
              ? TextEditingController.fromValue(
                  TextEditingValue(
                    text: controlledText ?? "",
                    composing: TextRange.collapsed(controlledText?.length ?? 0),
                  ),
                )
              : null);

  String get _text => initialText ?? _controller?.text ?? "";

  Widget _prefix(BuildContext context) => prefix != null || hintIcon != null
      ? Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (prefix != null) prefix,
            if (hintIcon != null)
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: IconTheme(
                  data: context.theme.iconTheme.copyWith(
                    size: 16,
                    color: context.theme.hintColor,
                  ),
                  child: hintIcon,
                ),
              ),
          ],
        )
      : null;

  @override
  Widget build(BuildContext context) => Container(
        padding: padding ?? EdgeInsets.zero,
        margin: margin ?? EdgeInsets.zero,
        color: background ?? Colors.transparent,
        child: TextFormField(
          initialValue: initialText,
          controller: _controller,
          focusNode: focusNode,
          autovalidateMode: _autovalidateMode,
          readOnly: _readOnly,
          keyboardType: keyboardType,
          obscureText: _obscureText,
          enableSuggestions: enableSuggestions ?? !_obscureText,
          autocorrect: enableSuggestions ?? !_obscureText,
          textInputAction: textInputAction,
          maxLength: maxLength,
          inputFormatters: inputFilters,
          minLines: minLines,
          maxLines: maxLines,
          onSaved: onSaved,
          validator: _validate,
          onTap: readOnly == true ? null : onTap,
          onChanged: onChanged,
          onFieldSubmitted: onSubmitted,
          textCapitalization: textCapitalization ?? TextCapitalization.none,
          style: style,
          textAlign: textAlign ?? TextAlign.start,
          autofocus: autofocus ?? false,
          expands: expands ?? false,
          toolbarOptions: toolbarOptions,
          showCursor: showCursor,
          obscuringCharacter: obscuringCharacter ?? "•",
          smartDashesType: smartDashesType,
          smartQuotesType: smartQuotesType,
          //maxLengthEnforced: maxLengthEnforcement ?? true,
          onEditingComplete: onEditingComplete,
          enabled: enabled ?? true,
          cursorWidth: cursorWidth ?? 2.0,
          cursorHeight: cursorHeight,
          cursorRadius: cursorRadius,
          cursorColor: cursorColor,
          keyboardAppearance: keyboardBrightness,
          scrollPadding: scrollPadding ?? const EdgeInsets.all(20.0),
          enableInteractiveSelection: enableInteractiveSelection ?? true,
          selectionControls: selectionControls,
          buildCounter: buildCounter,
          scrollPhysics: scrollPhysics,
          autofillHints: autofillHints,
          decoration: InputDecoration(
            prefix: _prefix(context),
            isDense: isDense,
            filled: filled,
            labelText: label,
            hintText: hint,
            helperText: helper ?? " ",
            helperMaxLines: helperMaxLines ?? 10,
            errorMaxLines: errorMaxLines ?? 10,
            errorText: error,
            suffix: suffix,
            counterText: showCounter ?? true ? counterText : "",
            icon: icon,
            labelStyle: labelStyle,
            helperStyle: helperStyle,
            hintStyle: hintStyle,
            hintMaxLines: hintMaxLines,
            errorStyle: errorStyle,
            floatingLabelBehavior:
                floatingLabelBehavior ?? FloatingLabelBehavior.auto,
            isCollapsed: isCollapsed ?? false,
            contentPadding: contentPadding,
            prefixIcon: prefixIcon,
            prefixIconConstraints: prefixIconConstraints,
            prefixText: prefixText,
            prefixStyle: prefixStyle,
            suffixIcon: suffixIcon,
            suffixText: suffixText,
            suffixStyle: suffixStyle,
            suffixIconConstraints: suffixIconConstraints,
            counter: showCounter ?? true ? counter : null,
            counterStyle: counterStyle,
            fillColor: fillColor,
            focusColor: focusColor,
            hoverColor: hoverColor,
            errorBorder: errorBorder,
            focusedBorder: focusedBorder,
            focusedErrorBorder: focusedErrorBorder,
            disabledBorder: disabledBorder,
            enabledBorder: enabledBorder,
            border: border,
            semanticCounterText: semanticCounterText,
            alignLabelWithHint: alignLabelWithHint,
          ),
        ),
      );
}
