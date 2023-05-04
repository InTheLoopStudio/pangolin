import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/models/service.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/onboarding_bloc/onboarding_bloc.dart';
import 'package:intheloopapp/ui/views/common/tapped_app_bar.dart';
import 'package:intheloopapp/ui/views/create_service/create_service_cubit.dart';
import 'package:intheloopapp/ui/widgets/common/forms/rate_text_field.dart';
import 'package:intheloopapp/ui/widgets/create_service_view/description_text_field.dart';
import 'package:intheloopapp/ui/widgets/create_service_view/rate_type_selector.dart';
import 'package:intheloopapp/ui/widgets/create_service_view/submit_service_button.dart';
import 'package:intheloopapp/ui/widgets/create_service_view/title_text_field.dart';

class CreateServiceView extends StatelessWidget {
  const CreateServiceView({
    required this.onCreated,
    super.key,
  });

  final void Function(Service) onCreated;

  @override
  Widget build(BuildContext context) {
    final database = context.read<DatabaseRepository>();
    final nav = context.read<NavigationBloc>();
    return BlocSelector<OnboardingBloc, OnboardingState, Onboarded>(
      selector: (state) => state as Onboarded,
      builder: (context, state) {
        return BlocProvider<CreateServiceCubit>(
          create: (context) => CreateServiceCubit(
            database: database,
            nav: nav,
            currentUserId: state.currentUser.id,
          ),
          child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            appBar: const TappedAppBar(
              title: 'Create Service',
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 32,
                  horizontal: 32,
                ),
                child: Column(
                  children: [
                    const TitleTextField(),
                    const SizedBox(height: 16),
                    const DescriptionTextField(),
                    const SizedBox(height: 16),
                    BlocBuilder<CreateServiceCubit, CreateServiceState>(
                      builder: (context, state) {
                        return RateTextField(
                          onChanged: (input) => context
                              .read<CreateServiceCubit>()
                              .onRateChange(input),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    const RateTypeSelector(),
                    const SizedBox(height: 16),
                    SubmitServiceButton(
                      onCreated: onCreated,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
