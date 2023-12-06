# boh_tourbuch

A new Flutter project.

## Getting Started

1) Download dependencies`flutter pub get`
2) Generate Code (needed for freezed)
    * 1x: `dart run build_runner build --delete-conflicting-outputs`
    * with watch: `dart run build_runner watch --delete-conflicting-outputs`


Identify dart (linting) problems `dart fix --dry-run`


## Release
Each push von the main branch creates a release.
Artefacts can be found here: https://gitlab.spree.de/saurer/boh_tourbuch/-/artifacts


## Bloc + freezed usage example


### State

For each status of the state you have to create a new factory method. The Parameters of each represents the values of
each status.
For easy working with the status values, it is very handy to use a freezed-object as value (e.g. for calling copyWith).

```dart
part of '<NAME>_bloc.dart';

enum <NAME>Status { initial, edit }

@freezed
class <NAME>State with _$<NAME>State {
   const factory <NAME>State({
      @Default(EditPersonDialogStatus.initial) <NAME>Status status,
      @Default('') String name
   }) = _<NAME>State;
}


```

### Event

Each event gets an own factory method

```dart
part of '<NAME>_bloc.dart';
@freezed
class <NAME>Event with _$<NAME>Event {
  const factory <NAME>Event.<EventName1>() = _<EventName1>; // e.g name could be loadData
  const factory <NAME>Event.<EventName2>(String name) = _<EventName2>; // event with data
}
```

### Bloc

It is important to add this part: `part '<NAME>_bloc.freezed.dart';`. Freezed requires a part definition, before the generator could work.

If any call in the event-handling is waiting for a future, all event-handler must be async (because of the initial await)

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part '<NAME>.freezed.dart';
part '<NAME>_bloc.freezed.dart';
part '<NAME>_event.dart';
part '<NAME>_state.dart';

class <NAME>Bloc extends Bloc<<NAME>Event, <NAME>State> {
  FaqBloc() : super(const <NAME>State()) {
    on<<NAME>Event>((event, emit) async {
      await event.when(
        <EventName1>: () async => emit(state.copyWith(status: <NAME>Status.edit)),
        <EventName2>: (arg) async => emit(state.copyWith(name: arg)),
      );
    });
  }
}
```