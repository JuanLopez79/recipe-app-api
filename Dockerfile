# Imagen liviana de python para Linux. Es ideal para contenedores Dcoker.
FROM python:3.9-alpine3.13 

# Etiqueta del mantenedor del contenedor. Es una buena practica ya que ayuda a identificar quien creo o mantiene el contenedor.
LABEL maintainer="juanprogramador.com"

# Le dice a Python que no almacene en buffer la salida, lo que es util para ver los logs en tiempo real.
ENV PYTHONUNBUFFERED=1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

# Se cambio a ARG para poder pasar el test de Github Actions.
# Esto se debe a que args permite instalar las dependencias de desarrollo.
# ENV no permite descargar dependencias de desarrollo.
# ENV DEV=false
ARG DEV=false 
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; \
    then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user
# Es buena practica NO USAR el usurio raiz (root user).
# Porque el root user tiene accesso completo a todo el sistema, lo que puede ser un riesgo de seguridad.


ENV PATH="/py/bin:$PATH" 

USER django-user