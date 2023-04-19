/*
Sso iOS & Android App
Copyright (C) 2022 Carlton Aikins

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

import 'package:buka_ea_khale/src/providers/local_user_repository_provider.dart';
import 'package:canton_ui/canton_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/constants.dart';

class ChangeLastNameCard extends ConsumerWidget {
  const ChangeLastNameCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _controller = TextEditingController();

    String currentNameStr() {
      return 'Fane: ' +
          ref.watch(localUserRepositoryProvider).getUser.lastName;
    }

    return CantonExpansionTile(
      title: Text(
        'Fetola Fane',
        style: Theme.of(context).textTheme.titleLarge,
      ),
      decoration: BoxDecoration(
        color: CantonMethods.alternateCanvasColorType3(context),
        borderRadius: BorderRadius.zero,
      ),
      backgroundColor: CantonMethods.alternateCanvasColor(context),
      iconColor: Theme.of(context).colorScheme.primary,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 17),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                currentNameStr(),
                style: Theme.of(context).textTheme.bodyText1,
              ),
              const SizedBox(height: 10),
              CantonTextInput(
                isTextFormField: true,
                obscureText: false,
                hintText: '',
                controller: _controller,
                containerPadding: const EdgeInsets.all(7),
              ),
              const SizedBox(height: 17),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CantonPrimaryButton(
                    buttonText: 'Confirm',
                    color: colorTheme,
                    textColor: Theme.of(context).colorScheme.onBackground,
                    containerWidth: 100,
                    containerHeight: 30,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    onPressed: () {
                      final updatedUser = ref
                          .read(localUserRepositoryProvider)
                          .getUser
                          .copyWith(lastName: _controller.text);
                      ref
                          .read(localUserRepositoryProvider)
                          .updateUser(updatedUser);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
