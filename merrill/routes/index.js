/*
 * GET home page.
 */

exports.index = function(req, res) {
		res.render('index');
};

exports.login = function(req, res) {
		if(req.method == 'GET') {
				res.render('login');
		} else if (req.method == 'POST') {
				res.redirect('/patient');
		}
};
