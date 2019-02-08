import React, {Component} from 'react';
import ReactDOM from 'react-dom';
import Test from './Test';

const e = React.createElement;

const domContainer = document.querySelector('#container');
ReactDOM.render(e(Test), domContainer);