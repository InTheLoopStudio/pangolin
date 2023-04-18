import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:intheloopapp/ui/themes.dart';
import 'package:intheloopapp/ui/views/settings/settings_cubit.dart';
import 'package:intheloopapp/ui/widgets/common/forms/artist_name_text_field.dart';
import 'package:intheloopapp/ui/widgets/common/forms/bio_text_field.dart';
import 'package:intheloopapp/ui/widgets/common/forms/instagram_text_field.dart';
import 'package:intheloopapp/ui/widgets/common/forms/location_text_field.dart';
import 'package:intheloopapp/ui/widgets/common/forms/soundcloud_text_field.dart';
import 'package:intheloopapp/ui/widgets/common/forms/tiktok_text_field.dart';
import 'package:intheloopapp/ui/widgets/common/forms/twitter_text_field.dart';
import 'package:intheloopapp/ui/widgets/common/forms/username_text_field.dart';
import 'package:intheloopapp/ui/widgets/common/forms/youtube_text_field.dart';
import 'package:intheloopapp/ui/widgets/settings_view/genre_selection.dart';
import 'package:intheloopapp/ui/widgets/settings_view/label_selection.dart';
import 'package:intheloopapp/ui/widgets/settings_view/occupation_selection.dart';
import 'package:intheloopapp/ui/widgets/settings_view/theme_switch.dart';

class SettingsForm extends StatelessWidget {
  const SettingsForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return Form(
          key: state.formKey,
          child: Column(
            children: [
              UsernameTextField(
                initialValue: state.username,
                onChanged: (input) {
                  if (input != null) {
                    context.read<SettingsCubit>().changeUsername(input);
                  }
                },
              ),
              ArtistNameTextField(
                onChanged: (input) =>
                    context.read<SettingsCubit>().changeArtistName(input ?? ''),
                initialValue: state.artistName,
              ),
              BioTextField(
                onChanged: (value) =>
                    context.read<SettingsCubit>().changeBio(value ?? ''),
                initialValue: state.bio,
              ),
              const OccupationSelection(),
              const LabelSelection(),
              const GenreSelection(),
              LocationTextField(
                onChanged: (place, placeId) =>
                    context.read<SettingsCubit>().changePlace(place, placeId),
                initialPlace: state.place,
                initialPlaceId: state.placeId,
              ),
              TwitterTextField(
                initialValue: state.twitterHandle,
                onChanged: (value) =>
                    context.read<SettingsCubit>().changeTwitter(value),
              ),
              InstagramTextField(
                initialValue: state.instagramHandle,
                onChanged: (value) =>
                    context.read<SettingsCubit>().changeInstagram(value),
              ),
              TikTokTextField(
                initialValue: state.tiktokHandle,
                onChanged: (value) =>
                    context.read<SettingsCubit>().changeTikTik(value),
              ),
              SoundcloudTextField(
                initialValue: state.soundcloudHandle,
                onChanged: (value) =>
                    context.read<SettingsCubit>().changeSoundcloud(value),
              ),
              YoutubeTextField(
                initialValue: state.youtubeChannelId,
                onChanged: (value) =>
                    context.read<SettingsCubit>().changeYoutube(value),
              ),
              const SizedBox(height: 15),
              const ThemeSwitch(),
              if (state.status.isInProgress)
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(tappedAccent),
                )
              else
                const SizedBox.shrink(),
            ],
          ),
        );
      },
    );
  }
}
