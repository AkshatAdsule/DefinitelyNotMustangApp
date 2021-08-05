import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:mustang_app/utils/stream_event.dart';

class FancyLoadingOverlay extends StatelessWidget {
  final Stream<StreamEvent> eventStream;
  final Widget content;
  final Widget loadingIndicator;
  final bool showOverlay;

  static const Widget defaultLoadingIndicator = CircularProgressIndicator();

  const FancyLoadingOverlay(
      {this.eventStream,
      this.content,
      this.showOverlay,
      this.loadingIndicator: defaultLoadingIndicator});

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: showOverlay,
      progressIndicator: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          loadingIndicator,
          SizedBox(
            height: 20,
          ),
          StreamBuilder(
            stream: eventStream,
            initialData: StreamEvent(
              message: "Waiting...",
              type: MessageType.INFO,
            ),
            builder: (context, AsyncSnapshot<StreamEvent> snapshot) {
              StreamEvent data = snapshot.data;
              Color textColor;

              switch (data.type) {
                case MessageType.INFO:
                  textColor = Colors.black;
                  break;
                case MessageType.WARNING:
                  textColor = Colors.orange;
                  break;
                case MessageType.ERROR:
                  textColor = Colors.red;
                  break;
              }

              return Text(
                data.message,
                style: TextStyle(color: textColor),
              );
            },
          ),
        ],
      ),
      child: content,
    );
  }
}
