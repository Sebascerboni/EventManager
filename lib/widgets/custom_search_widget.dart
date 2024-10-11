import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';

class CustomSearchWidget extends StatefulWidget {
  final TextEditingController controller;
  final List<String> items;
  final void Function(String) onItemSelected;

  const CustomSearchWidget({
    super.key,
    required this.controller,
    required this.items,
    required this.onItemSelected,
  });

  @override
  State<CustomSearchWidget> createState() => _CustomSearchWidgetState();
}

class _CustomSearchWidgetState extends State<CustomSearchWidget> {
  late List<String> _filteredItems;

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items; // Inicializa con los elementos proporcionados
    widget.controller.addListener(_onSearchChanged);
  }

  @override
  void didUpdateWidget(covariant CustomSearchWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items != widget.items) {
      // Si los elementos han cambiado, actualiza la lista filtrada y vuelve a aplicar el filtro de texto
      _onSearchChanged();
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onSearchChanged);
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      // Filtra los elementos según el texto ingresado por el usuario
      _filteredItems = widget.items
          .where((item) =>
              item.toLowerCase().contains(widget.controller.text.toLowerCase()))
          .toList();
    });
  }

  Widget _buildSearchChild(String text, {bool isSelected = false}) => Container(
        color: isSelected ? const Color.fromRGBO(128, 32, 179, 0.2) : Colors.white,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Text(
          text,
          style: const TextStyle(
            color: Color.fromRGBO(128, 32, 179, 1),
            fontFamily: 'Poppins',
            fontWeight: FontWeight.normal,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    // final RenderBox renderBox = context.findRenderObject() as RenderBox;
    // final sizeRender = renderBox.size;
    final size = MediaQuery.of(context).size;

    return LayoutBuilder(builder: (context, constraints) {
      final sizeRender = constraints.biggest;
      return Container(
        decoration: BoxDecoration(
          // color: Colors.transparent,
          borderRadius: BorderRadius.circular(sizeRender.width * 0.03),
        ),
        child: SearchField<String>(
          controller: widget.controller,
          hint: 'Buscar...',
          searchInputDecoration: SearchInputDecoration(
            labelText: 'Buscar',
            labelStyle: const TextStyle(
              color: Colors.white,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
            hintStyle: const TextStyle(
              color: Colors.white,
              fontFamily: 'Poppins',
              fontStyle: FontStyle.italic,
            ),
            // filled: true,
            // fillColor: Colors.transparent,
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
            /*suffixIcon: const Icon(
            Icons.arrow_drop_down,
            color: Colors.white,
          ),*/
          ),
          suggestionsDecoration: SuggestionDecoration(
            color: Colors.white, // Fondo blanco sólido
            borderRadius: BorderRadius.circular(10),
          ),
          suggestions: _filteredItems.map(
                (e) => SearchFieldListItem<String>(
              e,
              item: e,
              child: _buildSearchChild(e, isSelected: e == widget.controller.text),
            ),
          ).toList(),
          onSuggestionTap: (SearchFieldListItem<String> suggestion) {
            setState(() {
              widget.controller.text = suggestion.item!;
            });
            widget.onItemSelected(suggestion.item!);
            FocusScope.of(context).unfocus();
          },
        ),
      );
    });

  }
}
