import React, {Component} from 'react';
import classes from './JobHistory.module.css';

class JobHistory extends Component {

    render () {
        return (
            <div className = {classes.Image}>
                <div className={classes.Header}>
                    <h1>Reid Brostoff</h1>
                </div>
                <div className = {classes.projectBox}>
                    <p>Computer Science Teaching Assistant</p>
                    <strong>For: </strong><p>University of Wisconsin - Madison</p>
                    <strong>From: </strong><p>August 2020 - Present</p>
                    <strong>Responsibilities: </strong><p>Taught both undergraduate and graduate students in the "Programming I" (Comp Sci 200) class. Worked 10+ hours a week on top of taking personal classes. Honed STEM teaching skills by leading interactive labs and having personal office hours. Collaborated with fellow TA's under 
                    multiple professors to keep an 800+ student class functioning properly.</p>
                </div>
                <div className = {classes.projectBox}>
                <p>React.js & React Native<br/> Developer</p>
                    <strong>For: </strong><p>Filos</p>
                    <strong>From: </strong><p>October 2020 - Present</p>
                    <strong>Responsibilities: </strong><p>Work remotely with a diverse team, including neurobiology and data science graduate students, to create an application for use in clinical psychiatry, specifically autism. Position requires a dynamic understanding of 
                        front-end website development written in JavaScript and React.</p>
                </div>
                <div className = {classes.projectBox}>
                <p>Camp<br/>Counselor</p>
                    <strong>For: </strong><p>Camp Cedar</p>
                    <strong>From: </strong><p>June 2019 - August 2019</p>
                    <strong>Responsibilities: </strong><p>Supervised and mentored campers from around the world. Taught 6+ hours of tennis five days of week to both campers and fellow counselors. Organized, coached,
                         and refereed Tennis, Lacrosse, Soccer, and Basketball tournaments..</p>
                </div>
                <button onClick={this.props.setRedirectMain}>Back</button>
            </div>
        );
    }
}

export default JobHistory;