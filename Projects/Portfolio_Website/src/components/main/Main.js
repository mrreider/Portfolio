import React, { Component } from 'react';
import classes from './Main.module.css';

class Main extends Component {

  render() {
    return (
      <div className={classes.Image}>
        <div className={classes.Header}>
          <h1>Reid Brostoff</h1>
        </div>
        <div className={classes.Links}>
          <p>Index</p>
          <p onClick={this.props.setRedirectEducation}>Education & Accolades</p>
          <p onClick={this.props.setRedirectJobHistory}>Job History</p>
          <p onClick={this.props.setRedirectProjects}>Projects</p>
        </div>
      </div>
    );
  }
}

export default Main;