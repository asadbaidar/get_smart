import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_smart/get_smart.dart';

/// A wrapper of TextFormField with extended capabilities
class GetTextField extends StatelessWidget {
  const GetTextField({
    this.initialText,
    this.controlledText,
    this.controller,
    this.autovalidateMode,
    this.keyboardType,
    this.inputFormatters,
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
    this.dense,
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
    this.maxLengthEnforcement,
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
    this.collapsed = false,
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
    Key? key,
  })  : _key = key,
        super(key: null);

  /// If provided, it disables any explicit [controller].
  final String? initialText;

  /// Controlled by implicit controller and only effective if [initialText]
  /// and [controller] are not provided.
  final String? controlledText;

  /// To make it effective, don't provide [initialText].
  final TextEditingController? controller;

  final TextInputType? keyboardType;
  final AutovalidateMode? autovalidateMode;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final VoidCallback? onTap;
  final OnString? onSubmitted;
  final OnString? onSaved;
  final OnString? onChanged;
  final OnStringCallback<String?>? validator;
  final bool autoControlled;
  final bool? readOnly;
  final bool tapOnly;
  final bool? validateLength;
  final bool validateEmpty;
  final bool? showCounter;
  final bool? dense;
  final bool? filled;
  final bool? obscureText;
  final bool? enableSuggestions;
  final int? maxLength;
  final int? minLines;
  final int maxLines;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final Color? background;
  final TextCapitalization textCapitalization;
  final TextStyle? style;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final bool autofocus;
  final bool expands;
  final ToolbarOptions? toolbarOptions;
  final bool? showCursor;
  final String obscuringCharacter;
  final SmartDashesType? smartDashesType;
  final SmartQuotesType? smartQuotesType;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final VoidCallback? onEditingComplete;
  final bool enabled;
  final double cursorWidth;
  final double? cursorHeight;
  final Radius? cursorRadius;
  final Color? cursorColor;
  final Brightness? keyboardBrightness;
  final EdgeInsets scrollPadding;
  final bool enableInteractiveSelection;
  final TextSelectionControls? selectionControls;
  final InputCounterWidgetBuilder? buildCounter;
  final ScrollPhysics? scrollPhysics;
  final Iterable<String>? autofillHints;
  final String? label;
  final String? hint;
  final String? error;
  final String? helper;
  final Widget? hintIcon;
  final Widget? prefix;
  final Widget? suffix;
  final Widget? icon;
  final TextStyle? labelStyle;
  final TextStyle? helperStyle;
  final int? helperMaxLines;
  final TextStyle? hintStyle;
  final int? hintMaxLines;
  final TextStyle? errorStyle;
  final int? errorMaxLines;
  final FloatingLabelBehavior floatingLabelBehavior;
  final bool collapsed;
  final EdgeInsetsGeometry? contentPadding;
  final Widget? prefixIcon;
  final BoxConstraints? prefixIconConstraints;
  final String? prefixText;
  final TextStyle? prefixStyle;
  final Widget? suffixIcon;
  final String? suffixText;
  final TextStyle? suffixStyle;
  final BoxConstraints? suffixIconConstraints;
  final Widget? counter;
  final String? counterText;
  final TextStyle? counterStyle;
  final Color? fillColor;
  final Color? focusColor;
  final Color? hoverColor;
  final InputBorder? errorBorder;
  final InputBorder? focusedBorder;
  final InputBorder? focusedErrorBorder;
  final InputBorder? disabledBorder;
  final InputBorder? enabledBorder;
  final InputBorder? border;
  final String? semanticCounterText;
  final bool? alignLabelWithHint;
  final Key? _key;

  String get _hint => hint ?? label?.lowercase ?? GetText.value().lowercase;

  String? Function(String v) get _validator =>
      validator != null ? validator! : (v) => null;

  bool get _readOnly => readOnly == true || (tapOnly && onTap != null);

  bool get _obscureText => obscureText == true;

  String? _tryValidator(String? v) {
    try {
      return _validator(v ?? "");
    } catch (_) {
      return null;
    }
  }

  String? _validate(String? v) =>
      _tryValidator(v) ??
      (validateEmpty == true && v!.isEmpty
          ? GetText.please_enter([_hint])
          : validateLength == true && v!.length != maxLength
              ? GetText.invalid([_hint])
              : null);

  AutovalidateMode _autovalidateMode(context) =>
      autovalidateMode ??
      (Form.of(context)?.widget.onChanged != null
          ? Form.of(context)?.widget.autovalidateMode
          : null) ??
      ((validator != null ? _tryValidator(_text) != null : _text.isNotEmpty)
          ? AutovalidateMode.always
          : AutovalidateMode.onUserInteraction);

  TextEditingController? get _controller => initialText != null
      ? null
      : controller ??
          (autoControlled
              ? TextEditingController.fromValue(
                  TextEditingValue(
                    text: controlledText ?? "",
                    selection: TextSelection.fromPosition(TextPosition(
                      offset: controlledText?.length ?? 0,
                    )),
                  ),
                )
              : null);

  String get _text => initialText ?? _controller?.text ?? "";

  Widget? _prefix(BuildContext context) => prefix != null || hintIcon != null
      ? Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (prefix != null) prefix!,
            if (hintIcon != null)
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: IconTheme(
                  data: context.iconTheme.copyWith(
                    size: 16,
                    color: context.hintColor,
                  ),
                  child: hintIcon!,
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
          key: _key,
          initialValue: initialText,
          controller: _controller,
          focusNode: focusNode,
          autovalidateMode: _autovalidateMode(context),
          readOnly: _readOnly,
          keyboardType: keyboardType,
          obscureText: _obscureText,
          enableSuggestions: enableSuggestions ?? !_obscureText,
          autocorrect: enableSuggestions ?? !_obscureText,
          textInputAction: textInputAction,
          maxLength: maxLength,
          inputFormatters: inputFormatters,
          minLines: minLines,
          maxLines: maxLines,
          onSaved: (v) => onSaved?.call(v ?? ""),
          validator: _validate,
          onTap: readOnly == true ? null : onTap,
          onChanged: onChanged,
          onFieldSubmitted: onSubmitted,
          textCapitalization: textCapitalization,
          style: style,
          textAlign: textAlign,
          autofocus: autofocus,
          expands: expands,
          toolbarOptions: toolbarOptions,
          showCursor: showCursor,
          obscuringCharacter: obscuringCharacter,
          smartDashesType: smartDashesType,
          smartQuotesType: smartQuotesType,
          maxLengthEnforcement: maxLengthEnforcement,
          onEditingComplete: onEditingComplete,
          enabled: enabled,
          cursorWidth: cursorWidth,
          cursorHeight: cursorHeight,
          cursorRadius: cursorRadius,
          cursorColor: cursorColor,
          keyboardAppearance: keyboardBrightness,
          scrollPadding: scrollPadding,
          enableInteractiveSelection: enableInteractiveSelection,
          selectionControls: selectionControls,
          buildCounter: buildCounter,
          scrollPhysics: scrollPhysics,
          autofillHints: autofillHints,
          decoration: InputDecoration(
            prefix: _prefix(context),
            isDense: dense,
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
            floatingLabelBehavior: floatingLabelBehavior,
            isCollapsed: collapsed,
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

  static GlobalKey<FormFieldState> get newKey => GlobalKey<FormFieldState>();
}

/// An optional container for grouping together multiple form field widgets
/// (e.g. [GetTextField] widgets).
///
/// Each individual form field should be wrapped in a [FormField] widget, with
/// the [GetForm] widget as a common ancestor of all of those. Call methods on
/// [FormState] to save, reset, or validate each [FormField] that is a
/// descendant of this [GetForm]. To obtain the [FormState], you may use [GetForm.of]
/// with a context whose ancestor is the [GetForm], or pass a [GlobalKey] to the
/// [GetForm] constructor and call [GlobalKey.currentState].
///
/// This example shows a [GetForm] with one [GetTextField] to enter an email
/// address and an [ElevatedButton] to submit the form. A [GlobalKey] is used here
/// to identify the [GetForm] and validate input.

/// ```dart
/// final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
///
/// @override
/// Widget build(BuildContext context) {
///   return GetForm(
///     key: _formKey,
///     child: Column(
///       crossAxisAlignment: CrossAxisAlignment.start,
///       children: <Widget>[
///         GetTextField(
///           hint: 'Enter your email'
///           validator: (String? value) {
///             if (value == null || value.isEmpty) {
///               return 'Please enter some text';
///             }
///             return null;
///           },
///         ),
///         Padding(
///           padding: const EdgeInsets.symmetric(vertical: 16.0),
///           child: ElevatedButton(
///             onPressed: () {
///               // Validate will return true if the form is valid, or false if
///               // the form is invalid.
///               if (_formKey.currentState!.validate()) {
///                 // Process data.
///               }
///             },
///             child: const Text('Submit'),
///           ),
///         ),
///       ],
///     ),
///   );
/// }
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [FormField], a single form field widget that maintains the current state.
///  * [GetTextField], a wrapper of TextFormField with extended capabilities.
///  * [GetFilterableTextField], a wrapper of [GetTextField] with filterable suggestion features.
class GetForm extends StatelessWidget {
  /// Creates a container for form fields.
  ///
  /// The [child] argument must not be null.
  const GetForm({
    required this.child,
    this.onWillPop,
    this.onChanged,
    this.autovalidateMode,
    Key? key,
  })  : _key = key,
        super(key: null);

  final Key? _key;

  /// Returns the closest [FormState] which encloses the given context.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// FormState form = GetForm.of(context);
  /// form.save();
  /// ```
  static FormState? of(BuildContext context) => Form.of(context);

  /// The widget below this widget in the tree.
  ///
  /// This is the root of the widget hierarchy that contains this form.
  final Widget child;

  /// Enables the form to veto attempts by the user to dismiss the [ModalRoute]
  /// that contains the form.
  ///
  /// If the callback returns a Future that resolves to false, the form's route
  /// will not be popped.
  ///
  /// See also:
  ///
  ///  * [WillPopScope], another widget that provides a way to intercept the
  ///    back button.
  final WillPopCallback? onWillPop;

  /// Called when one of the form fields changes.
  ///
  /// In addition to this callback being invoked, all the form fields themselves
  /// will rebuild.
  final VoidCallback? onChanged;

  /// Used to enable/disable form fields auto validation and update their error
  /// text.
  final AutovalidateMode? autovalidateMode;

  @override
  Widget build(BuildContext context) => Form(
        key: _key,
        child: child,
        onWillPop: onWillPop,
        onChanged: onChanged ?? (autovalidateMode != null ? () {} : null),
        autovalidateMode: autovalidateMode,
      );
}
