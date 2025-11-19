import { PrismaClient, UserRole } from '@prisma/client';
import { generateAccessToken, generateRefreshToken } from '../utils/jwt';
import { hashPassword, comparePassword } from '../utils/password';
import { sendEmail } from '../utils/email';
import crypto from 'crypto';

const prisma = new PrismaClient();

export const login = async (email: string, password: string) => {
  const user = await prisma.user.findUnique({ where: { email } });

  if (!user) {
    throw new Error('Invalid credentials');
  }

  if (!user.emailVerified) {
    throw new Error('Email not verified');
  }

  const isPasswordValid = await comparePassword(password, user.password);

  if (!isPasswordValid) {
    throw new Error('Invalid credentials');
  }

  const payload = { id: user.id, role: user.role };
  const accessToken = generateAccessToken(payload);
  const refreshToken = generateRefreshToken(payload);

  return { accessToken, refreshToken };
};

export const me = async (id: number) => {
  const user = await prisma.user.findUnique({ where: { id } });

  if (!user) {
    throw new Error('User not found');
  }

  return user;
};

export const register = async (email: string, password: string, role: UserRole) => {
  const hashedPassword = await hashPassword(password);
  const verificationToken = crypto.randomBytes(32).toString('hex');

  const user = await prisma.user.create({
    data: {
      email,
      password: hashedPassword,
      role,
      verificationToken,
    },
  });

  const verificationUrl = `${process.env.BASE_URL}/api/v1/auth/verify-email?token=${verificationToken}`;

  await sendEmail({
    to: user.email,
    subject: 'Email Verification',
    html: `<p>Please verify your email by clicking this link: <a href="${verificationUrl}">${verificationUrl}</a></p>`,
  });

  return user;
};

export const verifyEmail = async (token: string) => {
  const user = await prisma.user.findUnique({ where: { verificationToken: token } });

  if (!user) {
    throw new Error('Invalid token');
  }

  await prisma.user.update({
    where: { id: user.id },
    data: { emailVerified: true, verificationToken: null },
  });
};
