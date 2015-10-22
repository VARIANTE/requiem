
'use strict';

let r = require('requiem');
let EventType = r.EventType;
let DirtyType = r.DirtyType;
let KeyCode = r.KeyCode;

class Bar extends r.Element {
  init() {
    this.bar = 'hello';

    r.Element.defineProperty(this, 'foo', {
      defaultValue: 1,
      dirtyType: DirtyType.DATA,
      attribute: 'data-foo',
      event: new Event(EventType.DATA.CHANGE),
      get: true,
      set: true
    });

    let b = this.getChild('button');
    b.setStyle('width', 50);
    b.setStyle('height', 30);
    b.setStyle('backgroundColor', '#000');
    b.addEventListener(EventType.MOUSE.CLICK, (event) => {
      this.foo++;
      console.log(this.foo);
    });

    super.init();
  }

  update() {
    if (this.isDirty(DirtyType.DATA)) {
      console.log('Data is dirty!');
    }

    super.update();
  }

  destroy() {
    super.destroy();
  }
}

module.exports = Bar;