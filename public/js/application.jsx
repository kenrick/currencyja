var SwitchButton = React.createClass({

  handleClick: function() {
    this.props.onSwitch(this.props.currencyName);
  },

  render: function() {
    var active = (this.props.current == this.props.currencyName) ? 'active' : '';
    return (
      <button onClick={this.handleClick} className={"btn btn-default " + active}>{this.props.currencyName}</button>
    );
  }

});

var AmountForm = React.createClass({
  handleChange: function() {
    var base = parseInt(this.refs.baseNumber.getDOMNode().value);

    if(!base) base = 1;

    this.props.onUserInput(base);
  },

  render: function() {
    return (
      <div className="currency-form">
        <form className="form-inline">
          <div className="form-group has-success">
            <input ref="baseNumber" name="base" onChange={this.handleChange} type="text" className="form-control" placeholder="Enter Amount" />
          </div>
        </form>
      </div>
    );
  }
});

var TraderRow = React.createClass({

  getPrice: function(type) {
    var props = this.props;
    var price = props.trader.currencies[props.currencyName][type] * props.base;

    return numeral(price).format('$0,0.00');
  },

  render: function() {
    var props = this.props;

    return (
      <tr className="trader">
        <td className="trader-name">{props.trader.name}</td>
        <td className="trader-buying">{this.getPrice('buy_cash')}</td>
        <td className="trader-buying">{this.getPrice('buy_draft')}</td>
        <td className="trader-selling">{this.getPrice('sell_cash')}</td>
        <td className="trader-selling">{this.getPrice('sell_draft')}</td>
      </tr>
    );
  }
});

var TradersTable = React.createClass({

  render: function() {
    var state = this.props.state;
    var rows = state.traders
              .sort(function(a, b) {
                return b.currencies[state.activeCurrency]['buy_cash'] - a.currencies[state.activeCurrency]['buy_cash'];
              })
              .map(function(trader){
                return <TraderRow key={trader.id} base={state.base} currencyName={state.activeCurrency} trader={trader} />;
              });

    return (
      <table className="traders-list table table-striped">
        <thead>
          <tr>
            <th>Trader</th>
            <th>Buy Cash</th>
            <th>Buy Draft</th>
            <th>Sell Cash</th>
            <th>Sell Draft</th>
          </tr>
        </thead>
        <tbody>
          {rows}
        </tbody>
      </table>
    );
  }
});

var SwitchableSortableCurrency = React.createClass({
  getInitialState: function() {
    return {
      base: 1,
      activeCurrency: 'USD',
      traders: this.props.traders
    }
  },

  handleCurrenySwitch: function(currencyName) {
    this.setState({
      activeCurrency: currencyName
    });
  },

  handleBaseChange: function(currentBase) {
    this.setState({
      base: currentBase
    });
  },

  render: function() {
    return(
      <div className="currencies">
        <div className="btn-group">
          <SwitchButton onSwitch={this.handleCurrenySwitch} current={this.state.activeCurrency} currencyName="USD" />
          <SwitchButton onSwitch={this.handleCurrenySwitch} current={this.state.activeCurrency} currencyName="GBP" />
          <SwitchButton onSwitch={this.handleCurrenySwitch} current={this.state.activeCurrency} currencyName="CAD" />
          <SwitchButton onSwitch={this.handleCurrenySwitch} current={this.state.activeCurrency} currencyName="EUR" />
        </div>
        <AmountForm onUserInput={this.handleBaseChange} />
        <TradersTable state={this.state} />
      </div>
    );
  }

});

React.render( <SwitchableSortableCurrency traders={gon.traders} />, document.getElementById('app'));

$(function() {
  $('time').timeago();
});
