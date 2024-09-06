class ModelEnums {
  static List<Model> models = [
    Model(
        name: "gpt-3.5-turbo",
        displayName: "GPT-3.5",
        description: "The latest version of GPT-3.5-turbo"),
    Model(
        name: "gpt-4o",
        displayName: "GPT-4",
        description: "The last version of GPT-4o"),
  ];
}

class Model {
  String name;
  String displayName;
  String description;
  Model(
      {required this.name,
      required this.displayName,
      required this.description});
}
