import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemini/core/size/sizes.dart';
import 'package:gemini/core/spacing/whitspacing.dart';
import 'package:gemini/core/widgets/default_button.dart';
import 'package:gemini/features/user/presentation/bloc/user_bloc.dart';
import 'package:gemini/locator.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

buildPickImage({
  required BuildContext context,
}) {
  return showModalBottomSheet(
      context: context,
      builder: (context) {
        final userBloc = sl<UserBloc>();
        return BlocListener(
            listener: (context, state) {
              if (state is PickImageLoaded) {
                final imageData=state.image;
                context.pop(imageData);
              }
              if(state is PickImageError){
                context.pop();
              }
            },
            bloc: userBloc,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: Sizes().width(context,0.04),
                vertical: Sizes().height(context,0.04),
              ),
              height: Sizes().height(context, 0.2),
              child: Column(
                children: [
                  DefaultButton(
                    label: "File",
                    onTap: () {
                      final Map<String, dynamic> params = {
                        "source": ImageSource.gallery
                      };
                      userBloc.add(
                        PickImageEvent(
                          params: params,
                        ),
                      );
                    },
                  ),
                  Space().height(context,0.02),
                  DefaultButton(
                    label: "Camera",
                    onTap: () {
                      final Map<String, dynamic> params = {
                        "source": ImageSource.camera
                      };
                      userBloc.add(
                        PickImageEvent(
                          params: params,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ));
      });
}
