import React, { Component } from 'react';
import classes from './Education.module.css';
import Modal from '../../UI/Modal/Modal';

class Education extends Component {

    state = {
        modalShowing: false,
        modalContent: <div>Hello</div>
    }

    closeModal = () => {
        this.setState({ modalShowing: false });
    }

    openModal = (id) => {
        const clubTenny = (
            <div className={classes.ModalStuff}>
                <strong>From: September 2019 - Present</strong> <br /><br />
                <strong>Responsibilities: </strong>Handle finances, budgeting, and oversee all transactions for the college club tennis team
            </div>
        );

        const adap = (
            <div className={classes.ModalStuff}>
                <strong>From: September 2016 - June 2018</strong> <br /><br />
                <strong>Responsibilities: </strong> Raised awareness and educated high school students about alcohol/drug use and abuse.
                Acted as a liasion between the executive board and the student lead peer group.
            </div>
        );

        const arSandbox = (
            <div className={classes.ModalStuff}>
                <strong>From: September 2019 - January 2020</strong> <br /><br />
                <strong>Responsibilities: </strong> Work alongside a diverse set of engineers to create an augmented reality experience for
                educational use. Virtual experience was created and changed depending on a physical box of sand. Was never finished due to COVID-19
            </div>
        );

        const allStateTennis = (
            <div className={classes.tennisModal}>
                <strong>2017 CT Class M Doubles State Champion </strong> <br/><br/>
                <strong>2018 CT Class M Doubles Runner Up</strong><br/><br/>
                CT All-State:<br /> 2017, 2018 <br/><br />
                SWC All Conference Academic Team:<br /> 2015, 2016, 2017, 2018
            </div>
        );

        if (id === 0) {
            this.setState({ modalContent: clubTenny })
        }
        else if (id === 1) {
            this.setState({ modalContent: arSandbox })
        }
        else if (id === 2) {
            this.setState({ modalContent: adap })
        }
        else if (id === 3){
            this.setState({modalContent: allStateTennis})
        }
        this.setState({ modalShowing: true })
    }

    render() {
        return (
            <div>
                <Modal show={this.state.modalShowing} modalClosed={this.closeModal}>
                    {this.state.modalContent}
                    <br />
                    <button className={classes.modalBack} onClick={this.closeModal}>Back</button>
                </Modal>
                <div className={classes.Image}>
                    <div className={classes.Header}>
                        <h1>Reid Brostoff</h1>
                    </div>
                    <div className={classes.projectBox}>
                        <br />
                        <strong>University of Wisconsin - Madison</strong><br />
                        <br />
                        <strong>Degree</strong><br />
                    B.S., Computer Engineering, Computer Science<br /><br />
                        <strong>GPA</strong><br />
                    3.45/4.0
                    <br />
                        <br />
                        <strong>Relevent Coursework</strong>
                        <p>
                            Calculus: Functions of Several Variables
                        <br />Discrete Mathematics
                        <br />Computer Science Programming (I & II & III)
                        <br />General Physics (I & II)
                        <br />Microprocessor Systems
                        <br />Circuits I
                        <br />Electrodynamics
                        <br />Introduction to Computer Architecture
                        <br />Digital System Design and Synthesis
                        <br />Machine Organization and Programming
                    </p>
                    </div>
                    <div className={classes.projectBox}>
                        <br />
                        <strong>Achievements & Positions</strong><br />
                        <br />
                        <strong>(Click on them to see more!)</strong><br /><br />
                        <p className={classes.ModalText} onClick={() => this.openModal(0)}>Treasurer, UW Madison Club Tennis</p>
                        <p className={classes.ModalText} onClick={() => this.openModal(1)}>Insight Wisconsin AR Sandbox Team</p>
                        <p className={classes.ModalText} onClick={() => this.openModal(2)}>President, Alcohol and Drug Awareness Program of Weston</p>
                        <p className={classes.ModalText} onClick={() => this.openModal(3)}>CT All-State Tennis Selection</p>
                    </div>
                    <button onClick={this.props.setRedirectMain}>Back</button>
                </div>
            </div>
        );
    }

}

export default Education;