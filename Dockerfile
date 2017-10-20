FROM alpine as build
WORKDIR /src
RUN apk add --no-cache yasm make binutils
COPY . .
RUN yasm --version
RUN make release

FROM scratch
COPY --from=build /src/asmttpd /bin/asmttpd
COPY --from=build /src/web_root /var/www
EXPOSE 80
CMD [ "/bin/asmttpd", "/var/www" ]

# Build:
# $ docker build -t asmttpd .

# Serve current directory:
# $ docker run -d --name asmttpd -p 80:80 -v $(pwd):/var/www asmttpd