FROM ubuntu:18.04 AS builder

WORKDIR /workspace

RUN apt-get update && \
    apt-get install -y \
	build-essential \
	git \
	cmake \
	automake \
	autoconf \
	libtool \
	m4 \
	pkg-config \
	libdrm-dev

RUN mkdir build build/usr build/lib

# Libva
RUN \
	git clone https://github.com/intel/libva.git  && \
	cd libva && \
	git checkout 2.22.0 && \
	./autogen.sh --prefix=/workspace/build/usr --libdir=/workspace/build/lib && \
	make -j$(nproc) && \
	make install && \
	cd -

# Gmmlib
RUN \
	git clone https://github.com/intel/gmmlib.git && \
	cd gmmlib && \
	git checkout intel-gmmlib-22.8.2 && \
	mkdir build && \
	cd build && \
	cmake -DCMAKE_INSTALL_PREFIX=/workspace/build/usr -DCMAKE_POLICY_VERSION_MINIMUM=3.5 -DCMAKE_INSTALL_LIBDIR=/workspace/build/lib -DCMAKE_BUILD_TYPE=ReleaseInternal .. && \
	make -j$(nproc) && \
	make install && \
	cd ../../

# Media Driver
RUN \
	git clone https://github.com/intel/media-driver.git && \
	cd media-driver && \
	mkdir build && \
	cd build && \
	export PKG_CONFIG_PATH=/workspace/build/lib/pkgconfig && \
	cmake -DCMAKE_LIBRARY_PATH=/workspace/build/lib -DCMAKE_INSTALL_PREFIX=/workspace/build/usr -DCMAKE_INSTALL_LIBDIR=/workspace/build/lib .. && \
	make -j$(nproc) && \
	make install

RUN find /workspace/build -name "*.so" -exec strip --strip-unneeded {} \;

FROM emby/embyserver:4.9.1.90 AS emby

COPY --from=builder /workspace/build/lib /lib