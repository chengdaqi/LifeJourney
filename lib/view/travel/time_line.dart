import 'package:flutter/material.dart';
import 'package:life_journey/component/styles.dart';
import 'package:life_journey/view/index/model/doodle.dart';
import 'package:life_journey/view/index/model/image_load_view.dart';
import 'package:timeline_list/timeline.dart';
import 'package:timeline_list/timeline_model.dart';

class TimeLinePage extends StatefulWidget {
  @override
  createState() => _TimeLinePageState();
}

class _TimeLinePageState extends State<TimeLinePage> with SingleTickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return Container(
        child: timelineModel(TimelinePosition.Right),
    );
  }

  timelineModel(TimelinePosition position) => Timeline.builder(
      itemBuilder: centerTimelineBuilder,
      itemCount: doodles.length,
      position: position);

  TimelineModel centerTimelineBuilder(BuildContext context, int i) {
    final doodle = doodles[i];
    final textTheme = Theme.of(context).textTheme;
    return TimelineModel(
        Card(
          margin: EdgeInsets.symmetric(vertical: 0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ImageLoadView(
                  doodle.doodle,
                  height: 150.0,
                  fit: BoxFit.cover,
                ),
                Gaps.vGap8,
                Text(doodle.time, style: textTheme.caption),
                Gaps.vGap8,
                Text(doodle.name,
                    style: textTheme.subtitle1, textAlign: TextAlign.center),
                Gaps.vGap8,
              ],
            ),
          ),
        ),
        position:
            i % 2 == 0 ? TimelineItemPosition.right : TimelineItemPosition.left,
        isFirst: i == 0,
        isLast: i == doodles.length,
        iconBackground: doodle.iconBackground,
        icon: doodle.icon);
  }
}
