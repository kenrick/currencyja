angular.module('currencyJa', [])
  .controller('TradersCtrl', ['$scope', 'traderService', function($scope, traderService) {
    $scope.currency = 'USD';
    $scope.traders = traderService.findByCurrency($scope.currency);

    $scope.multiplyByBase = function(amount) {
      var base = parseFloat($scope.base) || 1;
      if (amount) {
        return amount * base;
      }
    };

    $scope.changeCurrency = function(currency) {
      $scope.currency = currency;
      $scope.traders = traderService.findByCurrency($scope.currency);
    };
  }])
  .service('traderService', function() {
    this.findByCurrency = function(currency) {
      var statusMessages = {
        green: 'All good',
        red: 'Warning! outdated currencies'
      };

      return gon.traders.map(function(trader) {
        return {
          name: trader.name,
          shortName: trader.short_name,
          status: trader.status,
          statusMessage: statusMessages[trader.status],
          buyCash: trader.currencies[currency]['buy_cash'],
          buyDraft: trader.currencies[currency]['buy_draft'],
          sellCash: trader.currencies[currency]['sell_cash'],
          sellDraft: trader.currencies[currency]['sell_draft']
        };
      });
    };
  });
