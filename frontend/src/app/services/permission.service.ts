import { Injectable } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable } from 'rxjs';
import { ApiConfig, API_ENDPOINTS } from '../config/api.config';

export interface Permission {
  id: number;
  name: string;
  description: string;
  resource: string;
  action: string;
  is_active: boolean;
}

export interface PaginationInfo {
  current_page: number;
  per_page: number;
  total: number;
  total_pages: number;
  has_next: boolean;
  has_prev: boolean;
}

export interface PaginatedResponse<T> {
  data: T[];
  pagination: PaginationInfo;
}

export interface PermissionsResponse extends PaginatedResponse<Permission> {}

export interface PermissionResponse {
  permission: Permission;
}

export interface CreatePermissionRequest {
  name: string;
  description: string;
  resource: string;
  action: string;
}

export interface UpdatePermissionRequest {
  name?: string;
  description?: string;
  resource?: string;
  action?: string;
  is_active?: boolean;
}

@Injectable({
  providedIn: 'root'
})
export class PermissionService {
  constructor(private http: HttpClient, private apiConfig: ApiConfig) {}

  getPermissions(page: number = 1, perPage: number = 20): Observable<PermissionsResponse> {
    const params = new HttpParams()
      .set('page', page.toString())
      .set('per_page', perPage.toString());
    
    return this.http.get<PermissionsResponse>(`${this.apiConfig.permissionsApiUrl}${API_ENDPOINTS.PERMISSIONS.LIST}`, { params });
  }

  getPermission(id: number): Observable<PermissionResponse> {
    return this.http.get<PermissionResponse>(`${this.apiConfig.permissionsApiUrl}${API_ENDPOINTS.PERMISSIONS.DETAIL(id)}`);
  }

  createPermission(permissionData: CreatePermissionRequest): Observable<any> {
    return this.http.post(`${this.apiConfig.permissionsApiUrl}${API_ENDPOINTS.PERMISSIONS.CREATE}`, permissionData);
  }

  updatePermission(id: number, permissionData: UpdatePermissionRequest): Observable<any> {
    return this.http.put(`${this.apiConfig.permissionsApiUrl}${API_ENDPOINTS.PERMISSIONS.UPDATE(id)}`, permissionData);
  }

  deletePermission(id: number): Observable<any> {
    return this.http.delete(`${this.apiConfig.permissionsApiUrl}${API_ENDPOINTS.PERMISSIONS.DELETE(id)}`);
  }
}
