import { Request, Response } from 'express';
import { loginSchema, registerSchema, verifyEmailSchema } from '../validators/auth.validator';
import { login, me, register, verifyEmail } from '../services/auth.service';
import { AuthRequest } from '../middleware/auth';

export const loginController = async (req: Request, res: Response) => {
  try {
    const { email, password } = loginSchema.parse(req.body);
    const { accessToken, refreshToken } = await login(email, password);
    res.json({ accessToken, refreshToken });
  } catch (error: any) {
    res.status(400).json({ message: error.message });
  }
};

export const registerController = async (req: Request, res: Response) => {
  try {
    const { email, password, role } = registerSchema.parse(req.body);
    const user = await register(email, password, role);
    res.json(user);
  } catch (error: any) {
    res.status(400).json({ message: error.message });
  }
};

export const verifyEmailController = async (req: Request, res: Response) => {
  try {
    const { token } = verifyEmailSchema.parse(req.query);
    await verifyEmail(token);
    res.send('Email verified successfully');
  } catch (error: any) {
    res.status(400).json({ message: error.message });
  }
};

export const meController = async (req: AuthRequest, res: Response) => {
  try {
    const user = await me(req.user.id);
    res.json(user);
  } catch (error: any) {
    res.status(400).json({ message: error.message });
  }
};
