from fastapi import APIRouter, Request, HTTPException, FastAPI
from sqlalchemy import create_engine, Column, Integer, String, ForeignKey, Date
from sqlalchemy.orm import sessionmaker, relationship
from sqlalchemy.ext.declarative import declarative_base
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from datetime import datetime, timedelta
import logging

app = APIRouter()
app = FastAPI()

# Configuration des en-têtes CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["GET", "POST", "PUT", "DELETE"],
    allow_headers=["*"],
)

# Connexion à la base de données PetFlix
DATABASE_URL = "mysql://chaimaa:chaimaa@127.0.0.1:3306/PetFlix"
engine = create_engine(DATABASE_URL)

logging.info("Connexion à la base de données PetFlix")

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

class VideoData(BaseModel):
    titre: str
    description: str
    url: str
    date_ajout: str

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
    adoptions = relationship("Adoption", back_populates="animal")

class Membre(Base):
    __tablename__ = "membresAsso"
    id_membres = Column(Integer, primary_key=True, index=True)
    nom = Column(String, index=True)
    prenom = Column(String, index=True)
    ville = Column(String, index=True)
    email = Column(String, index=True)
    telephone = Column(String(30), default=None)

class Adoptant(Base):
    __tablename__ = "adoptant"
    id_adoptant = Column(Integer, primary_key=True, index=True)
    nom = Column(String, index=True)
    prenom = Column(String, index=True)
    adresse = Column(String)
    email = Column(String, unique=True, index=True)

class Adoption(Base):
    __tablename__ = "adoption"
    id = Column(Integer, primary_key=True, index=True)
    animal_id = Column(Integer, ForeignKey("animal.id_animal"))
    date_adoption = Column(Date)
    animal = relationship("Animal", back_populates="adoptions")
    
# Route pour récupérer la liste des adoptants enregistrés
@app.get("/get-adoptants")
async def list_adoptants(request: Request):
    try:
        db = SessionLocal()
        adoptants = db.query(Adoptant).all()
        
        adoptants_details = [
            {
                "id": adoptant.id_adoptant,
                "nom": adoptant.nom,
                "prenom": adoptant.prenom,
                "adresse": adoptant.adresse,
                "email": adoptant.email
            } for adoptant in adoptants
        ]
        
        return {"adoptants": adoptants_details}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Erreur lors de la récupération des adoptants : {str(e)}")

# Route pour récupérer la liste des animaux enregistrés en base
@app.get("/get-animaux")
async def list_animaux(request: Request):
    try:
        db = SessionLocal()
        animaux = db.query(Animal).all()
        
        animaux_details = [
            {
                "id": animal.id_animal,
                "type": animal.type,
                "nom": animal.nom,
                "age": animal.age,
                "date_arrive": animal.date_arrive.strftime("%Y-%m-%d"),
                "date_adoption": animal.date_adoption.strftime("%Y-%m-%d") if animal.date_adoption else None
            } for animal in animaux
        ]
        
        return {"animaux": animaux_details}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Erreur lors de la récupération des animaux : {str(e)}")

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
    
    video_details = {
        "id": video.id_video, 
        "titre": video.titre, 
        "description": video.description, 
        "url": video.url, 
        "date_ajout": video.date_ajout.strftime("%Y-%m-%d")
    }
    
    # détails de tous les animaux associés à la vidéo
    animals = db.query(Animal).filter(Animal.id_video == video_id).all()
    animals_details = []
    for animal in animals:
        # détails du membre de l'association associé à l'animal
        member = db.query(Membre).filter(Membre.id_membres == animal.id_membres).first()
        if member is None:
            raise HTTPException(status_code=404, detail=f"Membre non trouvé pour l'animal associé à la vidéo : {video_id}")
        
        animal_details = {
            "id": animal.id_animal,
            "type": animal.type,
            "nom": animal.nom,
            "age": animal.age,
            "date_arrive": animal.date_arrive.strftime("%Y-%m-%d"),
            "date_adoption": animal.date_adoption.strftime("%Y-%m-%d") if animal.date_adoption else None,
            "membre_associé": {
                "id": member.id_membres,
                "nom": member.nom,
                "prenom": member.prenom,
                "ville": member.ville,
                "email": member.email,
                "telephone": member.telephone
            }
        }
        animals_details.append(animal_details)
    
    return {
        "video": video_details,
        "animaux_associés": animals_details
    }

# Route pour ajouter une nouvelle vidéo d'adoption
@app.post("/create-video")
async def add_video(request: Request, video_data: VideoData):
    try:
        db = SessionLocal()
        
        date_ajout = datetime.strptime(video_data.date_ajout, "%Y-%m-%d").date()
        new_video = Video(titre=video_data.titre, description=video_data.description, url=video_data.url, date_ajout=date_ajout)
        
        db.add(new_video)
        db.commit()
        db.refresh(new_video)
        
        return {"message": "La vidéo d'adoption a été ajoutée avec succès", "id_video": new_video.id_video}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Erreur lors de l'ajout de la vidéo d'adoption : {str(e)}")
    
@app.get("/get-prochains-controles")
async def prochains_controles(request: Request):
    try:
        db = SessionLocal()

        date_actuelle = datetime.now()
        date_limite = date_actuelle - timedelta(days=180)

        # Requête pour récupérer les adoptions qui ont eu lieu il y a environ 6 mois
        adoptions = db.query(Adoption).filter(Adoption.date_adoption >= date_limite).all()

        prochains_controles = []
        for adoption in adoptions:
            animal = adoption.animal
            if animal is None:
                continue
            
            date_prochain_controle = adoption.date_adoption + timedelta(days=180)

            if date_prochain_controle > date_actuelle:
                prochains_controles.append({
                    "animal_id": animal.id_animal,
                    "nom": animal.nom,
                    "type": animal.type,
                    "date_adoption": adoption.date_adoption,
                    "date_prochain_controle": date_prochain_controle
                })

        return {"prochains_controles": prochains_controles}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Erreur lors de la récupération des prochains contrôles : {str(e)}")