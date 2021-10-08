import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/activity_bloc/bloc/activity_bloc.dart';

class NotificationIconButton extends StatelessWidget {
  const NotificationIconButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActivityBloc, ActivityState>(
      builder: (context, state) {
        return Container(
          width: 30,
          height: 30,
          child: Stack(
            children: [
              Container(
                child: Icon(
                  Icons.notifications,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              state.activities.any((elem) => elem.markedRead != false)
                  ? Positioned(
                      right: 0,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 1, vertical: 1),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 12,
                          minHeight: 12,
                        ),
                        child: Text(
                          '${state.activities.where((elem) => elem.markedRead == false).length}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
            ],
          ),
        );
      },
    );
  }
}
