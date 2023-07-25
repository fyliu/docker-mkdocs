# Guides ideas

???+ abstract "Todo"

    - [x] how to extend to install other plugins in ci.yml and Dockerfile
    - [x] optimize Dockerfile
    - [ ] docker multi-platform images https://plainenglish.io/blog/which-docker-images-can-you-use-on-the-mac-m1-daba6bbc2dc5
    - [ ] multirepo plugin
    - [ ] ~~[people depot] auto merge docs branch with gh-actions~~

## Needed guides
- [ ] setup ssh config, ssh public key, etc
- [ ] x forwarding through ssh session
- [ ] remote desktop into linux, xrdp setup
- [ ] PR keeping linear history by not merging branches, rebase instead
- [ ] git diagram example for git guide

## ToDo
- [x] set up mkdocs repo
- [x] add tilde pymdown extension for strikethrough text: https://yakworks.github.io/docmark/extensions/pymdown/ https://squidfunk.github.io/mkdocs-material/reference/formatting/
- [x] docker file for mkdocs project
- [x] local development using docker to run mkdocs
  - https://squidfunk.github.io/mkdocs-material/publishing-your-site/#material-for-mkdocs_1
- [x] github workflow to build gh-pages docs
- [x] build and upload docker image to dockerhub and use that image for development
  - https://github.com/squidfunk/mkdocs-material/blob/master/.github/workflows/build.yml
- [x] try docker image on website-wiki to see if it works.
- [ ] multi repo mkdocs with CTJ and Website Wiki
  - Fang: it doesn't work correctly. All the links are broken. It imports the nav from the remote repos and converts the links to <remote>/<docname>, but the imported docs are stores in <remote>/docs/<docname>
  - https://github.com/jdoiro3/mkdocs-multirepo-plugin
  - HfLA Website Docs: '!import https://hackforla.github.io/CivicTechJobs/?branch=main'
  - HfLA Website Docs: '!import https://github.com/hackforla/website-wiki?branch=main'
  - material theme, mkdocs documentation
  - https://github.com/squidfunk/mkdocs-material
