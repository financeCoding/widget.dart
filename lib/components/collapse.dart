library widget.collapse;

import 'dart:async';
import 'dart:html';
import 'package:polymer/polymer.dart';
import 'package:widget/effects.dart';
import 'package:widget/widget.dart';

/**
 * [CollapseWidget] uses a content model similar to [collapse functionality](http://twitter.github.com/bootstrap/javascript.html#collapse) in Bootstrap.
 *
 * The header element for [CollapseWidget] is a child element with class `accordion-heading`.
 *
 * The rest of the children are rendered as content.
 *
 * [CollapseWidget] listens for `click` events and toggles visibility of content if the
 * click target has attribute `data-toggle="collapse"`.
 */
@CustomTag('collapse-widget')
class CollapseWidget extends PolymerElement implements ShowHideComponent {
  static const String _collapseDivSelector = '.collapse-body-x';
  static final ShowHideEffect _effect = new ShrinkEffect();

  bool get applyAuthorStyles => true;

  bool _isShown = false;

  bool get isShown => _isShown;

  bool _insertedCalled = false;

  void set isShown(bool value) {
    assert(value != null);
    if(value != _isShown) {
      _isShown = value;
      _updateElements(!_insertedCalled);

      ShowHideComponent.dispatchToggleEvent(this);
    }
  }

  CollapseWidget.created() : super.created() {
    this.onClick.listen(_onClick);
  }

  Stream<Event> get onToggle => ShowHideComponent.toggleEvent.forTarget(this);

  void hide() {
    isShown = false;
  }

  void show() {
    isShown = true;
  }

  void toggle() {
    isShown = !isShown;
  }

  @override
  void enteredView() {
    super.enteredView();

    // TODO(jacobr): find a way to prevent animations upon calls to the isShown
    // setter that occur from the intial web_ui template binding that do not
    // require manually tracking _insertedCalled. If this.parent was null
    // when the template binding occurred we would be fine.
    _insertedCalled = true;
    _updateElements(true);
  }

  void _onClick(MouseEvent e) {
    if(!e.defaultPrevented) {
      final clickElement = e.target as Element;

      if(clickElement != null && clickElement.dataset['toggle'] == 'collapse') {
        toggle();
        e.preventDefault();
      }
    }
  }

  void _updateElements([bool skipAnimation = false]) {
    final collapseDiv = getShadowRoot('collapse-widget').querySelector(_collapseDivSelector);
    if(collapseDiv != null) {
      final action = _isShown ? ShowHideAction.SHOW : ShowHideAction.HIDE;
      final effect = skipAnimation ? null : _effect;
      ShowHide.begin(action, collapseDiv, effect: effect);
    }
  }
}
