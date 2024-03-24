from fastapi import APIRouter, Request, Depends, HTTPException
from sqlalchemy import create_engine, Column, Integer, String, ForeignKey, Date
from sqlalchemy.orm import sessionmaker, Session 
from sqlalchemy.ext.declarative import declarative_base
import logging

app = APIRouter()

logging.basicConfig(level=logging.INFO)

# Connexion à la base de données PetFlix
DATABASE_URL = "mysql://chaimaa:chaimaa@127.0.0.1:3306/PetFlix"
engine = create_engine(DATABASE_URL)

logging.info("Connexion à la base de données PetFlix")

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

# Définition des modèles SQLAlchemy
class Video(Base):
    __tablename__ = "video"
    id_video = Column(Integer, primary_key=True, index=True)
    titre = Column(String, index=True)
    description = Column(String)
    url = Column(String)
    date_ajout = Column(Date, index=True)

class Animal(Base):
    __tablename__ = "animal"
    id_animal = Column(Integer, primary_key=True, index=True)
    type = Column(String, index=True)
    nom = Column(String, index=True)
    age = Column(Integer, default=None)
    date_arrive = Column(Date, index=True)
    date_adoption = Column(Date, default=None)
    id_video = Column(Integer, ForeignKey("video.id_video"))
    id_membres = Column(Integer, ForeignKey("membresAsso.id_membres"))

class Membre(Base):
    __tablename__ = "membresAsso"
    id_membres = Column(Integer, primary_key=True, index=True)
    nom = Column(String, index=True)
    prenom = Column(String, index=True)
    ville = Column(String, index=True)
    email = Column(String, index=True)
    telephone = Column(String(30), default=None)

# Route pour récupérer les vidéos d'adoption avec un filtre sur les animaux et sur la ville des membres
@app.get("/videos/")
async def list_videos(request: Request, animal_type: str = None, member_city: str = None):
    db = SessionLocal()
    query = db.query(Video)
    
    # Filtrer par type d'animal
    if animal_type:
        query = query.join(Animal).filter(Animal.type == animal_type)
    
    # Filtrer par ville du membre asso
    if member_city:
        query = query.join(Animal, Membre).filter(Membre.ville == member_city)
    
    videos = query.all()
    
    video_details = [
        {
            "id": video.id_video, 
            "titre": video.titre, 
            "description": video.description, 
            "url": video.url, 
            "date_ajout": video.date_ajout.strftime("%Y-%m-%d")
        } for video in videos
    ]
    
    return {"videos": video_details}

# Route qui présente les animaux à adopter avec les coordonnées du membre de l’association
@app.get("/videos/{video_id}/details")
async def video_details(request: Request, video_id: int):
    db = SessionLocal()
    video = db.query(Video).filter(Video.id_video == video_id).first()
    if video is None:
        raise HTTPException(status_code=404, detail=f"Vidéo non trouvée : {video_id}")
    
    # Récupérer les détails de l'animal associé à la vidéo
    animal = db.query(Animal).filter(Animal.id_video == video_id).first()
    if animal is None:
        raise HTTPException(status_code=404, detail=f"Animal non trouvé pour la vidéo : {video_id}")
    
    # Récupérer les détails du membre de l'association
    member = db.query(Membre).filter(Membre.id_membres == animal.id_membres).first()
    if member is None:
        raise HTTPException(status_code=404, detail=f"Membre non trouvé pour l'animal associé à la vidéo : {video_id}")
    
    return {
        "video": {
            "id": video.id_video, 
            "titre": video.titre, 
            "description": video.description, 
            "url": video.url, 
            "date_ajout": video.date_ajout.strftime("%Y-%m-%d")
        },
        "animal": {
            "id": animal.id_animal,
            "type": animal.type,
            "nom": animal.nom,
            "age": animal.age,
            "date_arrive": animal.date_arrive.strftime("%Y-%m-%d"),
            "date_adoption": animal.date_adoption.strftime("%Y-%m-%d") if animal.date_adoption else None
        },
        "membre_associé": {
            "id": member.id_membres,
            "nom": member.nom,
            "prenom": member.prenom,
            "ville": member.ville,
            "email": member.email,
            "telephone": member.telephone
        }
    }
