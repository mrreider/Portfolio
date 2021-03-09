import React, {Component} from 'react';
import {Route, BrowserRouter as Router, Redirect} from 'react-router-dom';
import Main from './components/main/Main';
import Education from './components/education/Education';
import Projects from './components/projects/Projects';
import JobHistory from './components/JobHistory/JobHistory';


class App extends Component{

  state = {
    redirectMain: false,
    redirectEducation: false,
    redirectProjects: false,
    redirectJobHistory: false
  }

  setRedirectMain = () => {
    this.setState({redirectMain: true});
  }
  
  renderMain = () => {
    if (this.state.redirectMain){
      this.setState({redirectMain: false})
      return <Redirect to = '/'/>
    }
  }

  setRedirectEducation = () => {
    this.setState({redirectEducation: true})
  }

  renderEducation = () => {
    if (this.state.redirectEducation){
      this.setState({redirectEducation: false})
      return <Redirect to = '/Education'/>
    }
  }

  setRedirectProjects = () => {
    this.setState({redirectProjects: true});
  }

  renderProjects = () => {
    if (this.state.redirectProjects){
      this.setState({redirectProjects: false})
      return <Redirect to = '/Projects'/>
    }
  }

  setRedirectJobHistory = () => {
    this.setState({redirectJobHistory: true});
  }

  renderJobHistory = () => {
    if (this.state.redirectJobHistory){
      this.setState({redirectJobHistory: false})
      return <Redirect to = '/JobHistory'/>
    }
  }

  render() {

    return (
      <Router>
        {this.renderMain()}
        {this.renderEducation()}
        {this.renderProjects()}
        {this.renderJobHistory()}

        <Route path = '/' exact>
          <Main
          setRedirectEducation = {this.setRedirectEducation}
          setRedirectProjects = {this.setRedirectProjects}
          setRedirectJobHistory = {this.setRedirectJobHistory}
          />
        </Route>
        <Route path = '/Education'>
          <Education
          setRedirectMain = {this.setRedirectMain}
          />
        </Route>
        <Route path = '/Projects'>
          <Projects
          setRedirectMain = {this.setRedirectMain}
          />
        </Route>
        <Route path = '/JobHistory'>
          <JobHistory
          setRedirectMain = {this.setRedirectMain}/>
        </Route>
    </Router>
    );
  }

}

export default App;
