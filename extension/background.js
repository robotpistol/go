function navigate(url) {
  chrome.tabs.query({active: true, currentWindow: true}, function(tabs) {
    chrome.tabs.update(tabs[0].id, {url: url});
  });
}

chrome.omnibox.onInputEntered.addListener(function(text) {
  navigate('http://gomarks.herokuapp.com/' + text);
});

function search(query, callback) {
  var url = "http://gomarks.herokuapp.com/links/suggest?q=" + query;
  var req = new XMLHttpRequest();
  req.open("GET", url, true);
  req.onreadystatechange = function() {
    if (req.readyState == 4) {
      var data = JSON.parse(req.responseText);
      callback(data);
    }
  }
  req.send(null);
  return req;
}

chrome.omnibox.onInputChanged.addListener(
    function(text, suggest) {
      search(text, function(data) {
        var suggestions = [];
        for (var item in data) {
          suggestions.push({
            content: data[item],
            description: data[item],
          });
        }
        suggest(suggestions);

        chrome.omnibox.setDefaultSuggestion({
          description: text
        });
      });
    });
