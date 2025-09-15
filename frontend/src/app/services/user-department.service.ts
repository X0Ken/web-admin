import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Department } from './department.service';
import { ApiConfig, API_ENDPOINTS } from '../config/api.config';

export interface UserDepartment {
  id: number;
  user_id: number;
  department_id: number;
  position?: string;
  is_primary: boolean;
  created_at: string;
  updated_at: string;
  user?: {
    id: number;
    username: string;
    email: string;
  };
  department?: Department;
}

export interface AssignUserRequest {
  user_id: number;
  department_id: number;
  position?: string;
  is_primary?: boolean;
}

export interface BatchAssignRequest {
  user_ids: number[];
  department_id: number;
  position?: string;
}

export interface UpdateUserDepartmentRequest {
  position?: string;
  is_primary?: boolean;
}

export interface UserDepartmentResponse {
  data: UserDepartment;
  message?: string;
}

export interface UserDepartmentListResponse {
  data: UserDepartment[];
}

export interface BatchAssignResponse {
  message: string;
  data: {
    assigned_count: number;
    skipped_count: number;
    assignments: UserDepartment[];
  };
}

@Injectable({
  providedIn: 'root'
})
export class UserDepartmentService {
  constructor(private http: HttpClient, private apiConfig: ApiConfig) {}

  /**
   * 为用户分配部门
   */
  assignUser(request: AssignUserRequest): Observable<UserDepartmentResponse> {
    return this.http.post<UserDepartmentResponse>(`${this.apiConfig.userDepartmentsApiUrl}${API_ENDPOINTS.USER_DEPARTMENTS.ASSIGN}`, request);
  }

  /**
   * 批量分配用户到部门
   */
  batchAssignUsers(request: BatchAssignRequest): Observable<BatchAssignResponse> {
    return this.http.post<BatchAssignResponse>(`${this.apiConfig.userDepartmentsApiUrl}${API_ENDPOINTS.USER_DEPARTMENTS.BATCH_ASSIGN}`, request);
  }

  /**
   * 获取用户部门关联详情
   */
  getUserDepartment(id: number): Observable<UserDepartmentResponse> {
    return this.http.get<UserDepartmentResponse>(`${this.apiConfig.userDepartmentsApiUrl}${API_ENDPOINTS.USER_DEPARTMENTS.DETAIL(id)}`);
  }

  /**
   * 更新用户部门信息
   */
  updateUserDepartment(id: number, request: UpdateUserDepartmentRequest): Observable<UserDepartmentResponse> {
    return this.http.put<UserDepartmentResponse>(`${this.apiConfig.userDepartmentsApiUrl}${API_ENDPOINTS.USER_DEPARTMENTS.UPDATE(id)}`, request);
  }

  /**
   * 移除用户部门关联
   */
  removeUserDepartment(id: number): Observable<{ message: string }> {
    return this.http.delete<{ message: string }>(`${this.apiConfig.userDepartmentsApiUrl}${API_ENDPOINTS.USER_DEPARTMENTS.DELETE(id)}`);
  }

  /**
   * 获取用户的所有部门
   */
  getUserDepartments(userId: number): Observable<UserDepartmentListResponse> {
    return this.http.get<UserDepartmentListResponse>(`${this.apiConfig.userDepartmentsApiUrl}${API_ENDPOINTS.USER_DEPARTMENTS.USER_DEPARTMENTS(userId)}`);
  }

  /**
   * 获取用户的主要部门
   */
  getUserPrimaryDepartment(userId: number): Observable<UserDepartmentResponse> {
    return this.http.get<UserDepartmentResponse>(`${this.apiConfig.userDepartmentsApiUrl}${API_ENDPOINTS.USER_DEPARTMENTS.USER_PRIMARY(userId)}`);
  }

  /**
   * 获取部门的所有用户
   */
  getDepartmentUsers(departmentId: number): Observable<UserDepartmentListResponse> {
    return this.http.get<UserDepartmentListResponse>(`${this.apiConfig.userDepartmentsApiUrl}${API_ENDPOINTS.USER_DEPARTMENTS.DEPARTMENT_USERS(departmentId)}`);
  }
}
