mod auth;
mod database;
mod extractors;
mod middleware;
mod models;
mod rbac;
mod routes;
mod services;
mod utils;

use axum::{
    middleware::from_fn,
    routing::Router,
};
use std::net::SocketAddr;
use tower_http::cors::{Any, CorsLayer};
use tracing_subscriber::{layer::SubscriberExt, util::SubscriberInitExt};
use tokio::net::TcpListener;

use crate::{
    database::establish_connection,
    middleware::auth_middleware,
    routes::{auth_routes, user_routes, role_routes, permission_routes, department_routes, user_department_routes},
};

#[tokio::main]
async fn main() {
    // 初始化日志
    tracing_subscriber::registry()
        .with(tracing_subscriber::EnvFilter::new(
            std::env::var("RUST_LOG").unwrap_or_else(|_| "info".into()),
        ))
        .with(tracing_subscriber::fmt::layer())
        .init();

    // 加载环境变量
    dotenv::dotenv().ok();

    // 建立数据库连接
    let db = establish_connection()
        .await
        .expect("数据库连接失败");

    // 设置CORS
    let cors = CorsLayer::new()
        .allow_origin(Any)
        .allow_methods(Any)
        .allow_headers(Any);

    // 创建应用路由
    let app = Router::new()
        .nest("/api/auth", auth_routes())
        .nest("/api/users",
            user_routes()
                .layer(from_fn(auth_middleware))
        )
        .nest("/api/roles",
            role_routes()
                .layer(from_fn(auth_middleware))
        )
        .nest("/api/permissions",
            permission_routes()
                .layer(from_fn(auth_middleware))
        )
        .nest("/api/departments",
            department_routes()
                .layer(from_fn(auth_middleware))
        )
        .nest("/api/user-departments",
            user_department_routes()
                .layer(from_fn(auth_middleware))
        )
        .layer(cors)
        .with_state(db);

    // 启动服务器
    let addr = SocketAddr::from(([127, 0, 0, 1], 3000));
    tracing::info!("服务器启动在 http://{}", addr);

    let listener = TcpListener::bind(addr).await.unwrap();
    axum::serve(listener, app)
        .await
        .unwrap();
}
