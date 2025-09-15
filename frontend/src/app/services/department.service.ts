import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { ApiConfig, API_ENDPOINTS } from '../config/api.config';

export interface Department {
  id: number;
  name: string;
  description?: string;
  parent_id: number | null;
  manager_id: number | null;
  sort_order: number;
  created_at: string;
  updated_at: string;
  children?: Department[];
}

export interface CreateDepartmentRequest {
  name: string;
  description?: string;
  parent_id?: number | null;
  manager_id?: number | null;
  sort_order?: number;
}

export interface UpdateDepartmentRequest {
  name?: string;
  description?: string;
  parent_id?: number | null;
  manager_id?: number | null;
  sort_order?: number;
}

export interface DepartmentResponse {
  data: Department;
  message?: string;
}

export interface DepartmentListResponse {
  data: Department[];
}

export interface DepartmentTreeResponse {
  data: Department[];
}

@Injectable({
  providedIn: 'root'
})
export class DepartmentService {
  constructor(private http: HttpClient, private apiConfig: ApiConfig) {}

  /**
   * 获取部门列表
   */
  getDepartments(): Observable<DepartmentListResponse> {
    return this.http.get<DepartmentListResponse>(`${this.apiConfig.departmentsApiUrl}${API_ENDPOINTS.DEPARTMENTS.LIST}`);
  }

  /**
   * 获取部门树形结构
   */
  getDepartmentTree(): Observable<DepartmentTreeResponse> {
    return this.http.get<DepartmentTreeResponse>(`${this.apiConfig.departmentsApiUrl}${API_ENDPOINTS.DEPARTMENTS.TREE}`);
  }

  /**
   * 获取部门详情
   */
  getDepartment(id: number): Observable<DepartmentResponse> {
    return this.http.get<DepartmentResponse>(`${this.apiConfig.departmentsApiUrl}${API_ENDPOINTS.DEPARTMENTS.DETAIL(id)}`);
  }

  /**
   * 创建部门
   */
  createDepartment(department: CreateDepartmentRequest): Observable<DepartmentResponse> {
    return this.http.post<DepartmentResponse>(`${this.apiConfig.departmentsApiUrl}${API_ENDPOINTS.DEPARTMENTS.CREATE}`, department);
  }

  /**
   * 更新部门
   */
  updateDepartment(id: number, department: UpdateDepartmentRequest): Observable<DepartmentResponse> {
    return this.http.put<DepartmentResponse>(`${this.apiConfig.departmentsApiUrl}${API_ENDPOINTS.DEPARTMENTS.UPDATE(id)}`, department);
  }

  /**
   * 删除部门
   */
  deleteDepartment(id: number): Observable<{ message: string }> {
    return this.http.delete<{ message: string }>(`${this.apiConfig.departmentsApiUrl}${API_ENDPOINTS.DEPARTMENTS.DELETE(id)}`);
  }
}
