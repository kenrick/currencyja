var CurrencyJa = new (Backbone.View.extend({

  Models: {},
  Collections: {},
  Views: {},

  start: function(bootstrap){
    var traders = new CurrencyJa.Collections.Traders(bootstrap);
    var tradersList = new CurrencyJa.Views.TradersList({collection: traders});
    var currencyButtons = new CurrencyJa.Views.CurrencyButtons({collection: traders})
    var currencyForm = new CurrencyJa.Views.CurrencyForm({collection: traders});
    $("#app").append(currencyButtons.render().el);
    $("#app").append(currencyForm.render().el);
    $("#app").append(tradersList.render().el);
  }

}))({el: document.body});

// The Trader Model
CurrencyJa.Models.Trader = Backbone.Model.extend({
  defaults: {currency: 'usd', base: 1},
  buying: function(){
    return this.get('currencies')[this.get('currency')]['buying'] * this.get('base');
  },

  selling: function(){
    return this.get('currencies')[this.get('currency')]['selling'] * this.get('base');
  }
});

// The Traders Collection
CurrencyJa.Collections.Traders = Backbone.Collection.extend({
  model: CurrencyJa.Models.Trader,
  comparator: function(trader1, trader2){
    return trader1.get('currencies')['usd']['buying'] < trader2.get('currencies')['usd']['buying']
  },

  updateBase: function(base) {
    this.each(function(model){
      model.set('base', base);
    }, this);
  },

  changeCurrency: function(currency) {
    this.each(function(model){
      model.set('currency', currency);
    }, this);
  }
});

CurrencyJa.Views.Trader = Backbone.View.extend({
  template: _.template(
      '<td class="trader-name"><%= model.get("name") %></td>' +
      '<td class="trader-buying"><%= model.buying().toFixed(2) %></td>' +
      '<td class="trader-selling"><%= model.selling().toFixed(2) %></td>'
  ),
  className: 'trader',
  tagName: 'tr',

  initialize: function(){
    this.listenTo(this.model, 'change', this.render)
  },

  render: function(){
    this.$el.html(this.template({model: this.model}));
    return this;
  }
});

CurrencyJa.Views.TradersList = Backbone.View.extend({
  className: 'traders-list table table-striped',
  tagName: 'table',
  template: _.template(
    '<thead>' +
      '<tr>' +
        '<th>Trader</th>' +
        '<th>Buying</th>' +
        '<th>Selling</th>' +
      '</tr>' +
    '</thead>'+
    '<tbody>'+
    '</tbody>'
  ),

  initialize: function(){
  },

  addTrader: function(trader){
    var view = new CurrencyJa.Views.Trader({model: trader});
    this.$('tbody').append(view.render().el);
  },

  render: function(){
    this.$el.html(this.template());
    this.collection.each(this.addTrader, this);
    return this;
  }
});

CurrencyJa.Views.CurrencyForm = Backbone.View.extend({
  template: _.template(
    '<form> <input class="input-small" name="base" type="text" value="<%= base %>" />' +
    ' <span class="label label-success">JMD</span>' +
    '</form>'
  ),

  events: {
    "keyup input[name=base]": 'updateBase'
  },
  className: 'currency-form',
  tagName: 'div',

  updateBase: function(e) {
    var base = parseFloat(this.$("input[name=base]").val());
    if(isNaN(base) || base === 0){
      base = 1;
    }

    this.collection.updateBase(base);
  },

  render: function(){
    this.$el.html(this.template({base: 1}));
    return this;
  }
});

CurrencyJa.Views.CurrencyButtons = Backbone.View.extend({
  template: _.template(
    '<div class="btn-group">' +
      '<button class="btn active">usd</button>' +
      '<button class="btn">gbp</button>' +
      '<button class="btn">cad</button>' +
    '</div>'
  ),

  events: {
    "click .btn": 'changeCurrency'
  },
  className: 'currencies',
  tagName: 'div',

  changeCurrency: function(e) {
    this.$(".btn").removeClass('active');
    var $el = this.$(e.target);
    $el.addClass('active');
    var currency = $el.text();

    this.collection.changeCurrency(currency);
  },

  render: function(){
    this.$el.html(this.template());
    return this;
  }
});




// Start the app
jQuery(function($){
  var bootstrap = $("#app").data('traders');
  CurrencyJa.start(bootstrap);
});
