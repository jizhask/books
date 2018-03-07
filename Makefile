all:
	cd fsbook-xswitch && make
docker:
	docker pull dujinfang/texlive_pandoc

dockerrun:
	docker run --rm -it -v ${PWD}:/team dujinfang/texlive_pandoc bash
