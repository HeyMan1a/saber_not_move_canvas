
import 'package:flutter/material.dart';
import 'package:saber/components/canvas/_canvas_background_painter.dart';
import 'package:saber/components/canvas/color_extensions.dart';
import 'package:saber/components/canvas/inner_canvas.dart';
import 'package:saber/data/editor/editor_core_info.dart';
import 'package:saber/i18n/strings.g.dart';

class EditorBottomSheet extends StatefulWidget {
  const EditorBottomSheet({
    super.key,
    required this.invert,
    required this.coreInfo,
    required this.setBackgroundPattern,
    required this.clearPage,
    required this.clearAllPages,
  });

  final bool invert;
  final EditorCoreInfo coreInfo;
  final void Function(String) setBackgroundPattern;
  final VoidCallback clearPage;
  final VoidCallback clearAllPages;

  @override
  State<EditorBottomSheet> createState() => _EditorBottomSheetState();
}

class _EditorBottomSheetState extends State<EditorBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: IntrinsicHeight(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 500,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: !widget.coreInfo.isEmpty ? TextButton.styleFrom(
                            backgroundColor: colorScheme.primary,
                            foregroundColor: colorScheme.onPrimary,
                          ) : null,
                          onPressed: !widget.coreInfo.isEmpty ? () {
                            widget.clearPage();
                            Navigator.pop(context);
                          } : null,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.delete),
                              const SizedBox(width: 8),
                              Text(t.editor.menu.clearPage),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          style: !widget.coreInfo.isEmpty ? TextButton.styleFrom(
                            backgroundColor: colorScheme.primary,
                            foregroundColor: colorScheme.onPrimary,
                          ) : null,
                          onPressed: !widget.coreInfo.isEmpty ? () {
                            widget.clearAllPages();
                            Navigator.pop(context);
                          } : null,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.delete_sweep),
                              const SizedBox(width: 8),
                              Text(t.editor.menu.clearAllPages),
                            ],
                          )
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (final String backgroundPattern in CanvasBackgroundPatterns.all) ...[
                          InkWell(
                            borderRadius: BorderRadius.circular(8),
                            onTap: () => setState(() {
                              widget.setBackgroundPattern(backgroundPattern);
                            }),
                            child: Container(
                              width: 150,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: colorScheme.primary.withOpacity(0.5).withSaturation(widget.coreInfo.backgroundPattern == backgroundPattern ? 1 : 0),
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: FittedBox(
                                  child: SizedBox(
                                    width: widget.coreInfo.width / 5,
                                    height: widget.coreInfo.height / 5,
                                    child: CustomPaint(
                                      painter: CanvasBackgroundPainter(
                                        invert: widget.invert,
                                        backgroundColor: widget.coreInfo.backgroundColor ?? InnerCanvas.defaultBackgroundColor,
                                        backgroundPattern: backgroundPattern,
                                        primaryColor: colorScheme.primary.withSaturation(widget.coreInfo.backgroundPattern == backgroundPattern ? 1 : 0),
                                        secondaryColor: colorScheme.secondary.withSaturation(widget.coreInfo.backgroundPattern == backgroundPattern ? 1 : 0),
                                        preview: true,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
