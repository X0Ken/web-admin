import { Injectable } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable } from 'rxjs';
import { ApiConfig, API_ENDPOINTS } from '../config/api.config';

export interface User {
  id: number;
  username: string;
  email: string;
  is_active: boolean;
  permissions: string[];
  roles: string[];
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

export interface UsersResponse extends PaginatedResponse<User> {}

export interface UserResponse {
  user: User;
}

export interface CreateUserRequest {
  username: string;
  email: string;
  password: string;
}

export interface UpdateUserRequest {
  email?: string;
  is_active?: boolean;
}

export interface AssignRoleRequest {
  role_id: number;
}

@Injectable({
  providedIn: 'root'
})
export class UserService {
  constructor(private http: HttpClient, private apiConfig: ApiConfig) {}

  getUsers(page: number = 1, perPage: number = 20): Observable<UsersResponse> {
    const params = new HttpParams()
      .set('page', page.toString())
      .set('per_page', perPage.toString());
    
    return this.http.get<UsersResponse>(`${this.apiConfig.usersApiUrl}${API_ENDPOINTS.USERS.LIST}`, { params });
  }

  getUser(id: number): Observable<UserResponse> {
    return this.http.get<UserResponse>(`${this.apiConfig.usersApiUrl}${API_ENDPOINTS.USERS.DETAIL(id)}`);
  }

  createUser(userData: CreateUserRequest): Observable<any> {
    return this.http.post(`${this.apiConfig.usersApiUrl}${API_ENDPOINTS.USERS.CREATE}`, userData);
  }

  updateUser(id: number, userData: UpdateUserRequest): Observable<any> {
    return this.http.put(`${this.apiConfig.usersApiUrl}${API_ENDPOINTS.USERS.UPDATE(id)}`, userData);
  }

  deleteUser(id: number): Observable<any> {
    return this.http.delete(`${this.apiConfig.usersApiUrl}${API_ENDPOINTS.USERS.DELETE(id)}`);
  }

  assignRole(userId: number, roleId: number): Observable<any> {
    return this.http.post(`${this.apiConfig.usersApiUrl}${API_ENDPOINTS.USERS.ASSIGN_ROLE(userId)}`, { role_id: roleId });
  }
}
