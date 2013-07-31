import 'dart:html';
import 'package:polymer/polymer.dart';
import 'package:widget/effects.dart';
import 'package:widget/widget.dart';
import 'package:bot/bot.dart';

/**
 * [AccordionWidget] wraps a set of [Collapse] elements and ensures only one is visible
 * at a time.
 *
 * See [Collapse] for details on how content is interpreted.
 */
class AccordionWidget extends PolymerElement {
  @protected
  void created() {
    ShowHideComponent.toggleEvent.forTarget(this).listen(_onOpen);
  }

  List<Element> _getAllCollapseElements() =>
      this.queryAll('[is=x-accordion] > [is=x-collapse]');

  void _onOpen(Event openEvent) {
    Element target = openEvent.target;
    if (target.xtag is ShowHideComponent) {
      _onShowHideToggle(target.xtag);
    }
  }

  void _onShowHideToggle(ShowHideComponent shc) {
    if (shc.isShown) {
      _getAllCollapseElements()
        .map((Element e) => e.xtag)
        .where((e) => e != shc)
        .forEach((ShowHideComponent e) {
          e.hide();
        });
    }
  }
}
