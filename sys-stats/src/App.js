import logo from './logo.svg';
import './App.css';
import React, { Component } from 'react';

class App extends Component {

  constructor(props) {
    super();
    this.state = {
      cpu: 0,
      ram: 0
    }
    this.loadData = this.loadData.bind(this)
  }

  componentDidMount() {
    this.loadData()
    setInterval(this.loadData, 300);
  }

  async loadData() {
    try {
      const res = await fetch('/api/stats');
      const blocks = await res.json();
      const ram = blocks.ram;
      const cpu = blocks.cpu;
      console.log(ram);
      this.setState({
        cpu, ram
      })
    } catch (e) {
      console.log(e);
    }
  }


  render() {
    return (
      <div className="App" >
        <header className="App-header">
          <img src={logo} className="App-logo" alt="logo" />
          <div>
            <h3>CPU : {this.state.cpu}</h3>
            <h3>RAM : {this.state.ram}</h3>
          </div>
        </header>
      </div>
    );
  }
}
export default App;
