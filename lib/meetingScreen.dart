import 'package:flutter/material.dart';
import 'package:videosdk/videosdk.dart';
import 'people.dart';
import 'controls.dart';

class StartScreen extends StatefulWidget {
  final String meetingId;
  final String token;

  const StartScreen(
      {super.key, required this.meetingId, required this.token});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  late Room _room;
  var micEnabled = true;
  var camEnabled = false;

  Map<String, Participant> participants = {};

  @override
  void initState() {
    // create room
    _room = VideoSDK.createRoom(
      roomId: widget.meetingId,
      token: widget.token,
      displayName: "Test",
      micEnabled: micEnabled,
      camEnabled: camEnabled//,
      // defaultCameraIndex: kIsWeb
      //     ? 0
      //     : 1  // Index of MediaDevices will be used to set default camera
    );

    setMeetingEventListener();

    // Join room
    _room.join();

    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  // listening to meeting events
  void setMeetingEventListener() {
    _room.on(Events.roomJoined, () {
      setState(() {
        participants.putIfAbsent(
            _room.localParticipant.id, () => _room.localParticipant);
      });
    });

    _room.on(
      Events.participantJoined,
      (Participant participant) {
        setState(
          () => participants.putIfAbsent(participant.id, () => participant),
        );
      },
    );

    _room.on(Events.participantLeft, (String participantId) {
      if (participants.containsKey(participantId)) {
        setState(
          () => participants.remove(participantId),
        );
      }
    });

    _room.on(Events.roomLeft, () {
      participants.clear();
      Navigator.popUntil(context, ModalRoute.withName('/'));
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VideoSDK QuickStart'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(widget.meetingId),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    mainAxisExtent: 300,
                  ),
                  itemBuilder: (context, index) {
                    return ParticipantTile(
                      key: Key(participants.values.elementAt(index).id),
                        participant: participants.values.elementAt(index));
                  },
                  itemCount: participants.length,
                ),
              ),
            ),
            MeetingControls(
              onToggleMicButtonPressed: () {
                micEnabled ? _room.muteMic() : _room.unmuteMic();
                micEnabled = !micEnabled;
              },
              onToggleCameraButtonPressed: () {
                camEnabled ? _room.disableCam() : _room.enableCam();
                camEnabled = !camEnabled;
              },
              onLeaveButtonPressed: () {
                _room.leave();
              },
            ),
          ],
        ),
      ),
    );
  }
}