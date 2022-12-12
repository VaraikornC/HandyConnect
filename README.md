# handyConnect
CPE327 Final Project

### IMPORTANT:

For projects with Firestore integration, you must first run the following commands to ensure the project compiles:

```
flutter pub get
flutter packages pub run build_runner build --delete-conflicting-outputs
flutter pub run flutter_launcher_icons:main
```

This command creates the generated files that parse each Record from Firestore into a schema object.
