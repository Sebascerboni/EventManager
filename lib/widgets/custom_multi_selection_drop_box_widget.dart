import 'package:flutter/material.dart';

class CustomMultiSelectionDropBox<T> extends StatefulWidget {
  final List<T> items;
  final ValueChanged<List<T>> onChanged;
  final String labelText;
  final String hintText;
  final String Function(T) displayValue;

  final FocusNode? focusNode;
  final ValueChanged<String>? onFieldSubmited;
  final bool? autofocus;

  final List<T>? initialSelectedItems;

  const CustomMultiSelectionDropBox({
    super.key,
    required this.items,
    required this.onChanged,
    required this.labelText,
    required this.hintText,
    required this.displayValue,
    this.focusNode,
    this.onFieldSubmited,
    this.autofocus,
    this.initialSelectedItems,
  });

  @override
  CustomMultiSelectionDropBoxState<T> createState() =>
      CustomMultiSelectionDropBoxState<T>();
}

class CustomMultiSelectionDropBoxState<T>
    extends State<CustomMultiSelectionDropBox<T>>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  Set<T> _selectedItems = {};
  late AnimationController _controller;
  late Animation<double> _heightFactor;
  late TextEditingController _textController;
  OverlayEntry? _overlayEntry;
  bool _isHovering = false;

  final LayerLink _layerLink = LayerLink();

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _heightFactor =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _textController = TextEditingController();
    if (widget.initialSelectedItems != null) {
      _selectedItems = widget.initialSelectedItems!.toSet();
      _textController.text = _selectedItems.map(widget.displayValue).join(', ');
    }

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _controller.dispose();
    _textController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    if (_overlayEntry != null) {
      _toggleDropdown(); // Cierra el dropdown si está abierto
    }
  }

  void clearCustomMultiSelectionDropBoxInputs() {
    _textController.clear();
    setState(() {
      _selectedItems = {};
    });
  }

  void _toggleDropdown() {
    if (_overlayEntry == null) {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
      _controller.forward();
    } else {
      _overlayEntry?.remove();
      _overlayEntry = null;
      _controller.reverse();
    }
  }

  void setSelectedItems(List<T> items) {
    setState(() {
      _selectedItems = items.toSet();
      _textController.text = _selectedItems.map(widget.displayValue).join(', ');
    });
  }


  OverlayEntry _createOverlayEntry() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    return OverlayEntry(
      builder: (context) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: _toggleDropdown,
          child: Container(
            color: Colors.transparent,
            child: Stack(
              children: [
                Positioned(
                  left: offset.dx,
                  top: offset.dy + size.height,
                  width: size.width,
                  child: CompositedTransformFollower(
                    link: this._layerLink,
                    child: Material(
                      color: Colors.transparent,
                      child: SizeTransition(
                        sizeFactor: _heightFactor,
                        axisAlignment: -1.0,
                        child: GestureDetector(
                          onTap: () {
                            _toggleDropdown();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: const Color.fromRGBO(128, 32, 179, 1),
                                  width: 1),
                              borderRadius:
                                  BorderRadius.circular(size.width * 0.03),
                              color: Colors.white,
                            ),
                            constraints: BoxConstraints(
                              maxHeight: size.height *
                                  3, // Ajusta la altura máxima del dropdown
                            ),
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                  scrollbarTheme: ScrollbarThemeData(
                                    thumbColor: WidgetStateProperty.all(
                                      const Color.fromRGBO(79, 20, 107, 1.0),
                                  ),
                                    thickness: WidgetStateProperty.all(5),
                                )
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: widget.items.map((T value) {
                                    bool isSelected = _selectedItems.contains(value);
                                    bool isHovered = false;
                                    return StatefulBuilder(
                                      builder: (BuildContext context,
                                          StateSetter setState) {
                                        return MouseRegion(
                                          onEnter: (_) {
                                            setState(() {
                                              isHovered = true;
                                            });
                                          },
                                          onExit: (_) {
                                            setState(() {
                                              isHovered = false;
                                            });
                                          },
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                if (isSelected) {
                                                  _selectedItems.remove(value);
                                                } else {
                                                  _selectedItems.add(value);
                                                }
                                                _textController.text = _selectedItems
                                                    .map(widget.displayValue)
                                                    .join(
                                                        ', '); // Update the text controller
                                                widget.onChanged(
                                                    _selectedItems.toList());

                                                // Actualiza el dropdown sin cerrarlo
                                                _overlayEntry
                                                    ?.markNeedsBuild(); // Rebuild the overlay to reflect changes
                                              });
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 8, vertical: 12),
                                              decoration: BoxDecoration(
                                                color: isSelected
                                                    ? const Color.fromRGBO(
                                                    128, 32, 179, 0.2)
                                                    : isHovered ? const Color.fromRGBO(
                                                    128, 32, 179, 0.2)
                                                    : Colors.transparent,
                                                borderRadius: BorderRadius.circular(size.width * 0.025),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Text(
                                                    widget.displayValue(value),
                                                    style: const TextStyle(
                                                      color: Color.fromRGBO(
                                                          128, 32, 179, 1),
                                                      fontFamily: 'Poppins',
                                                    ),
                                                  ),
                                                  if (isSelected)
                                                    const Icon(
                                                      Icons.check,
                                                      color: Color.fromRGBO(
                                                          128, 32, 179, 1),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const hoverColor = Color.fromRGBO(128, 32, 179, 0.2);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        setState(() {
          _isHovering = true;
        });
      },
      onExit: (_) {
        setState(() {
          _isHovering = false;
        });
      },
      child: CompositedTransformFollower(
        link: this._layerLink,
        child: GestureDetector(
          onTap: _toggleDropdown,
          child: AbsorbPointer(
            child: TextField(
              controller: _textController,
              readOnly: true,
              focusNode: widget.focusNode,
              onSubmitted: widget.onFieldSubmited,
              onTap: _toggleDropdown,
              decoration: InputDecoration(
                labelText: widget.labelText,
                labelStyle: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
                hintText: widget.hintText,
                hintStyle: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins',
                  fontStyle: FontStyle.italic,
                ),
                filled: true,
                fillColor: _isHovering ? hoverColor : Colors.transparent,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(size.width * 0.008),
                  borderSide: BorderSide(
                      color: Colors.white, width: size.width * 0.0007),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(size.width * 0.008),
                  borderSide: BorderSide(
                      color: Colors.white, width: size.width * 0.0007 * 3),
                ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: size.height * 0.02,
                  horizontal: size.width * 0.0125,
                ),
                suffixIcon: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
