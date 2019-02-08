import React, {Component} from 'react';

export class Test extends Component {
  render() {
    return React.createElement("div", null,
       React.createElement("h3", null, "Hello world")
    );
  }
}