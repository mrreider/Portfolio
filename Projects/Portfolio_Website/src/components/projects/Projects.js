import React, { Component } from 'react';
import NewWindow from 'react-new-window';
import classes from './Projects.module.css';

class Projects extends Component {

    state = {
        javaHelpText: <p className={classes.lame2}>September 2020</p>,
        cHelpText: <p className={classes.lame2}>November 2020</p>,
        verilogHelpTexT: <p className={classes.lame2}>February 2021</p>,
        javascriptHelpText: <p className={classes.lame2}>Updated Constantly!</p>
    }
    render() {
        const helpText = <p className={classes.lame1}>Click to go to GitHub</p>
        return (
            <div className={classes.Image}>
                <div className={classes.Header}>
                    <h1>Reid Brostoff</h1>
                    <h2>Projects</h2>
                </div>
                <div className={classes.projectBox}>
                    <p onMouseOver={() => this.setState({ cHelpText: helpText })}
                        onMouseOut={() => this.setState({ cHelpText: <p className={classes.lame2}>November 2020</p> })}
                        onClick={() => window.open('https://github.com/mrreider/Portfolio/tree/main/Projects/MSP432_Scope_Shooter', '_blank')}
                        >C Project 353</p>
                    {this.state.cHelpText}
                </div>
                <div className={classes.projectBox}>
                    <p onMouseOver={() => this.setState({ javaHelpText: helpText })}
                        onMouseOut={() => this.setState({ javaHelpText: <p className={classes.lame2}>September 2020</p> })}
                        onClick={() => window.open('https://github.com/mrreider/Portfolio/tree/main/Projects/Hashtable', '_blank')}>
                        Java Hashtable</p>
                    {this.state.javaHelpText}
                </div>
                <div className={classes.projectBox}>
                    <p onMouseOver={() => this.setState({ verilogHelpTexT: helpText })}
                        onMouseOut={() => this.setState({ verilogHelpTexT: <p className={classes.lame2}>February 2021</p> })}
                        onClick={() => window.open('https://github.com/mrreider/Portfolio/tree/main/Projects/SV%20UART', '_blank')}
                        >System Verilog UART</p>
                    {this.state.verilogHelpTexT}
                </div>
                <div className={classes.projectBox}>
                    <p onMouseOver={() => this.setState({ javascriptHelpText: helpText })}
                        onMouseOut={() => this.setState({ javascriptHelpText: <p className={classes.lame2}>Updated Constantly!</p> })}
                        onClick={() => window.open('https://github.com/mrreider/Portfolio/tree/main/Projects/Portfolio_Website', '_blank')}
                        >This website</p>
                    {this.state.javascriptHelpText}
                </div>
                <button onClick={this.props.setRedirectMain}>Back</button>
            </div>
        );
    }
}

export default Projects;