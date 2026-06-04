FROM node:24-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN DATABASE_URL=postgres://placeholder \
    BETTER_AUTH_SECRET=placeholder_build_secret_32chars_xx \
    ORIGIN=http://localhost:3000 \
    GITHUB_CLIENT_ID=placeholder \
    GITHUB_CLIENT_SECRET=placeholder \
    npm run build

FROM node:24-alpine
WORKDIR /app
COPY --from=builder /app/build ./build
COPY --from=builder /app/package*.json ./
RUN npm ci --omit=dev
ENV PORT=3000
EXPOSE 3000
CMD ["node", "build"]
