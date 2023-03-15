import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intheloopapp/ui/widgets/common/forms/location_form/location_cubit.dart';

class LocationResults extends StatelessWidget {
  const LocationResults({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationCubit, LocationState>(
      builder: (context, state) {
        if (state.loading) {
          return const Center(
            child: SpinKitWave(
              color: Colors.white,
              size: 25,
            ),
          );
        }

        if (state.locationResults.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search,
                  size: 200,
                  color: Color(0xFF757575),
                ),
                Text(
                  'Search',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF757575),
                  ),
                ),
              ],
            ),
          );
        } else if (state.locationResults.isEmpty) {
          return const Center(
            child: Text('No users found'),
          );
        } else {
          return ListView.builder(
            itemCount: state.locationResults.length,
            itemBuilder: (BuildContext context, int index) {
              final prediction = state.locationResults[index];
              return ListTile(
                onTap: () {
                  context.read<LocationCubit>().saveLocation(prediction);
                },
                leading: const Icon(CupertinoIcons.location_fill),
                title: Text(prediction.primaryText),
                subtitle: Text(prediction.secondaryText),
              );
            },
          );
        }
      },
    );
  }
}
