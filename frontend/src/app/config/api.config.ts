import { Injectable } from '@angular/core';

/**
 * API配置服务
 * 统一管理所有API端点的配置
 */
@Injectable({
  providedIn: 'root'
})
export class ApiConfig {
  private readonly BASE_URL = 'http://localhost:3000';
  private readonly API_VERSION = 'api';

  /**
   * 获取基础API URL
   */
  get baseApiUrl(): string {
    return `${this.BASE_URL}/${this.API_VERSION}`;
  }

  /**
   * 获取认证相关API URL
   */
  get authApiUrl(): string {
    return `${this.baseApiUrl}/auth`;
  }

  /**
   * 获取用户相关API URL
   */
  get usersApiUrl(): string {
    return `${this.baseApiUrl}/users`;
  }

  /**
   * 获取角色相关API URL
   */
  get rolesApiUrl(): string {
    return `${this.baseApiUrl}/roles`;
  }

  /**
   * 获取权限相关API URL
   */
  get permissionsApiUrl(): string {
    return `${this.baseApiUrl}/permissions`;
  }

  /**
   * 获取部门相关API URL
   */
  get departmentsApiUrl(): string {
    return `${this.baseApiUrl}/departments`;
  }

  /**
   * 获取用户部门关联相关API URL
   */
  get userDepartmentsApiUrl(): string {
    return `${this.baseApiUrl}/user-departments`;
  }

  /**
   * 构建完整的API URL
   * @param endpoint 端点路径
   * @returns 完整的API URL
   */
  buildUrl(endpoint: string): string {
    // 确保endpoint以/开头
    if (!endpoint.startsWith('/')) {
      endpoint = '/' + endpoint;
    }
    return `${this.baseApiUrl}${endpoint}`;
  }

  /**
   * 构建特定模块的API URL
   * @param module 模块名称
   * @param endpoint 端点路径
   * @returns 完整的API URL
   */
  buildModuleUrl(module: string, endpoint: string = ''): string {
    const baseUrl = `${this.baseApiUrl}/${module}`;
    if (!endpoint) {
      return baseUrl;
    }
    if (!endpoint.startsWith('/')) {
      endpoint = '/' + endpoint;
    }
    return `${baseUrl}${endpoint}`;
  }
}

/**
 * API端点常量
 * 定义所有API端点的路径
 */
export const API_ENDPOINTS = {
  // 认证相关
  AUTH: {
    LOGIN: '/login',
    REGISTER: '/register',
    REFRESH: '/refresh',
    ME: '/me'
  },
  
  // 用户相关
  USERS: {
    LIST: '',
    DETAIL: (id: number) => `/${id}`,
    CREATE: '',
    UPDATE: (id: number) => `/${id}`,
    DELETE: (id: number) => `/${id}`,
    ASSIGN_ROLE: (id: number) => `/${id}/roles`
  },

  // 角色相关
  ROLES: {
    LIST: '',
    DETAIL: (id: number) => `/${id}`,
    CREATE: '',
    UPDATE: (id: number) => `/${id}`,
    DELETE: (id: number) => `/${id}`,
    ASSIGN_PERMISSION: (id: number) => `/${id}/permissions`,
    REMOVE_PERMISSION: (id: number) => `/${id}/permissions`
  },

  // 权限相关
  PERMISSIONS: {
    LIST: '',
    DETAIL: (id: number) => `/${id}`,
    CREATE: '',
    UPDATE: (id: number) => `/${id}`,
    DELETE: (id: number) => `/${id}`
  },

  // 部门相关
  DEPARTMENTS: {
    LIST: '',
    TREE: '/tree',
    DETAIL: (id: number) => `/${id}`,
    CREATE: '',
    UPDATE: (id: number) => `/${id}`,
    DELETE: (id: number) => `/${id}`
  },

  // 用户部门关联相关
  USER_DEPARTMENTS: {
    ASSIGN: '/assign',
    BATCH_ASSIGN: '/batch-assign',
    DETAIL: (id: number) => `/${id}`,
    UPDATE: (id: number) => `/${id}`,
    DELETE: (id: number) => `/${id}`,
    USER_DEPARTMENTS: (userId: number) => `/user/${userId}`,
    USER_PRIMARY: (userId: number) => `/user/${userId}/primary`,
    DEPARTMENT_USERS: (deptId: number) => `/department/${deptId}`
  }
} as const;
