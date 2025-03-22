Map<String, dynamic> extractSoojiHalwaIngredients(
    Map<String, dynamic> soojiHalwaData) {
  return {
    "name": soojiHalwaData["recipe_name"],
    "ingredients": (soojiHalwaData["ingredients"] as List).map((ingredient) {
      return {
        "name": ingredient["name"],
        "quantity": ingredient["quantity"],
        "checked": false,
      };
    }).toList(),
  };
}
