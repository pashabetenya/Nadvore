# Weather.

The Weather application, spelled out on clean architecture.

## Getting Started.

This project is a starting point for a Flutter application.

How do I start it up?

Terminal:

```
- gh repo clone pashabetenya/Nadvore.
```

IDE VS Code:

```
file, pubspec.yaml:

- flutter pub get packages.
```

```
file, main.dart:

- flutter run.
```

## The basic layers in a clean architecture.

## Presentation Layer:

```
This layer handles user input, and displays data on the screen. It should
not depend on other layers, and should provide an interface to interact with the user.
```

## Application Layer:

```
This layer contains the business logic, and manages all interactions between the layers. It depends
on the view layer, but is independent of the other layers.
```

## Domain Layer:

```
This layer contains the underlying business logic, and data models that are used by the application.
It should not depend on the lower layers,
and should be independent of frameworks and libraries.
```

## Infrastructure Layer:

```
This layer contains the implementation of infrastructure, such as databases, network services,
caching, etc. It depends on the domain layer, but should not depend on other layers.
```

### Review.

<table>
  <tr>
    <td>Weather - 1.</td>
    <td>Weather - 2.</td>
  </tr>
  <tr>
    <td><img src="photos/image-1.png" width=270 height=480></td>
    <td><img src="photos/image-1.1.png" width=270 height=480></td>
  </tr>
 </table>
