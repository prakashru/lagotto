[![Build Status](https://travis-ci.org/articlemetrics/alm.png?branch=master)](https://travis-ci.org/articlemetrics/alm)
[![Code Climate](https://codeclimate.com/github/articlemetrics/alm.png)](https://codeclimate.com/github/articlemetrics/alm)
[![Code Climate Test Coverage](https://codeclimate.com/github/articlemetrics/alm/coverage.png)](https://codeclimate.com/github/articlemetrics/alm)

The Ruby on Rails application Article-Level Metrics (ALM) was started in March 2009 by the Open Access publisher [Public Library of Science (PLOS)](http://www.plos.org/). It allows a user to aggregate relevant performance data on research articles, including how often an article has been viewed, cited, saved, discussed and recommended. We’re continuing to expand the Article-Level Metrics application because we believe that articles should be considered on their own merits, and that the impact of an individual article should not be determined by the journal in which it happened to be published. As a result, we hope that new ways of measuring and evaluating research quality (or ‘impact’) can and will evolve. To learn more about Article-Level Metrics, see the [SPARC ALM primer](http://www.sparc.arl.org/resource/sparc-article-level-metrics-primer) or visit the [website](http://articlemetrics.github.io).

## How to start developing now?

`ALM` uses [Vagrant](https://www.vagrantup.com/) and [Virtualbox](https://www.virtualbox.org/) for setting up the development environment. To start developing now on your local machine (Mac OS X, Linux or Windows):

1. Install Vagrant: https://www.vagrantup.com/downloads.html
1. Install Virtualbox: https://www.virtualbox.org/wiki/Downloads
2. Clone this repository `git clone git@github.com:articlemetrics/alm.git`
3. Cd into it and run `vagrant up`

Once the setup is complete (it might take up to 20 minutes), you'll be able to open up a browser and navigate to [http://10.2.2.4](http://10.2.2.4), and you should see this screen:

![ALM screenshot](https://github.com/articlemetrics/alm-report/blob/master/app/asstes/images/start.png)

## Documentation
Detailed instructions on how to start developing are [here](https://github.com/articlemetrics/alm-report/blob/master/docs/installation.md). There is extensive documentation at the [project website](http://articlemetrics.github.io).

## Mailing List
Please direct questions about the application to the [mailing list].

[mailing list]: https://groups.google.com/group/plos-api-developers

## Note on Patches/Pull Requests

* Fork the project
* Write tests for your new feature or a test that reproduces a bug
* Implement your feature or make a bug fix
* Do not mess with Rakefile, version or history
* Commit, push and make a pull request. Bonus points for topical branches.

## License
ALM Reports is released under the [Apache 2 License](https://github.com/articlemetrics/alm/blob/master/LICENSE.md).
