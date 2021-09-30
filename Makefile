# remove all dsn when there is no connection to a database
# use the makefile for windows
# run at VAL@VaL MINGW64 /d/big_golang/trevor_intermediate/go-stripe $
# make start, make stop, make start_back, make start_front, make stop_back, make stop_front

SHELL=cmd
STRIPE_SECRET=sk_test_51JTTCQF8BSRYOicWK261iBEGnpPw9wCbi60TcLIxPYv5WX4fYuwdZH6txDrt7lt2XANjv7u5wmX6LsIdTOQeEF9f00LGgCQpCZ
STRIPE_KEY=pk_test_51JTTCQF8BSRYOicWv0KF2beQMaMKgA60oviFdbCQ6sSjMXV4q9CJlPvFnuKzZQG0fDyLtnSgVDuVw2zbaEGBRxLq00DtUu1r2a
GOSTRIPE_PORT=4000
API_PORT=4001

# comment this when there is no database connection
DSN="root:1234@(localhost:3306)/widgets?parseTime=true&tls=false"

# remove all dsn below when there is no db connection

## build: builds all binaries
build: clean build_front build_back
	@echo All binaries built!

## clean: cleans all binaries and runs go clean
clean:
	@echo Cleaning...
	@echo y | DEL /S dist
	@go clean
	@echo Cleaned and deleted binaries

## build_front: builds the front end
build_front:
	@echo Building front end...
	@go build -o dist/gostripe.exe ./cmd/web
	@echo Front end built!

## build_back: builds the back end
build_back:
	@echo Building back end...
	@go build -o dist/gostripe_api.exe ./cmd/api
	@echo Back end built!

## start: starts front and back end
start: start_front start_back

## start_front: starts the front end
# set STRIPE_KEY=${STRIPE_KEY}&& set STRIPE_SECRET=${STRIPE_SECRET}&& start /B .\dist\gostripe.exe -dsn=${DSN}
# @env STRIPE_KEY=${STRIPE_KEY} STRIPE_SECRET=${STRIPE_SECRET} ./dist/gostripe -port=${GOSTRIPE_PORT} &
start_front: build_front
	@echo Starting the front end...
	set STRIPE_KEY=${STRIPE_KEY}&& set STRIPE_SECRET=${STRIPE_SECRET}&& start /B .\dist\gostripe.exe -dsn=${DSN}
	@echo Front end running!

## start_back: starts the back end
# set STRIPE_KEY=${STRIPE_KEY}&& set STRIPE_SECRET=${STRIPE_SECRET}&& start /B .\dist\gostripe_api.exe -dsn=${DSN}
# @env STRIPE_KEY=${STRIPE_KEY} STRIPE_SECRET=${STRIPE_SECRET} ./dist/gostripe_api -port=${API_PORT} &
start_back: build_back
	@echo Starting the back end...
	set STRIPE_KEY=${STRIPE_KEY}&& set STRIPE_SECRET=${STRIPE_SECRET}&& start /B .\dist\gostripe_api.exe -dsn=${DSN}
	@echo Back end running!

## stop: stops the front and back end
stop: stop_front stop_back
	@echo All applications stopped

## stop_front: stops the front end
stop_front:
	@echo Stopping the front end...
	@taskkill /IM gostripe.exe /F
	@echo Stopped front end

## stop_back: stops the back end
stop_back:
	@echo Stopping the back end...
	@taskkill /IM gostripe_api.exe /F
	@echo Stopped back end

# ## stop_front: stops the front end
# stop_front:
# 	@echo "Stopping the front end..."
# 	@-pkill -SIGTERM -f "gostripe -port=${GOSTRIPE_PORT}"
# 	@echo "Stopped front end"

# ## stop_back: stops the back end
# stop_back:
# 	@echo "Stopping the back end..."
# 	@-pkill -SIGTERM -f "gostripe_api -port=${API_PORT}"
# 	@echo "Stopped back end"