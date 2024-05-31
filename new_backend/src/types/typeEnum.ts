export enum Subject {
    Biology = 'Biology',
    Chemistry = 'Chemistry',
    Civics = 'Civics',
    English = 'English',
    Mathematics = 'Mathematics',
    Physics = 'Physics',
    SAT = 'SAT',
    Economics = 'Economics',
    History = 'History',
    Business = 'Business',
    Geography = 'Geography',
    Others = 'Others',
    Generic = 'Generic'
}

export enum PrizeType {
    CASH = 'cash',
    ITEM = 'item',
    SPECIAL = 'special',
    COIN= 'coin'
}

export enum RegionEnum {
    ADDIS_ABABA = "Addis Ababa",
    AFAR_REGION = "Afar Region",
    AMHARA_REGION = "Amhara Region",
    BENISHANGUL_GUMUZ_REGION = "Benishangul-Gumuz Region",
    CENTRAL_ETHIOPIA_REGIONAL_STATE = "Central Ethiopia Regional State",
    DIRE_DAWA = "Dire Dawa",
    GAMBELA_REGION = "Gambela Region",
    HARARI_REGION = "Harari Region",
    OROMIA_REGION = "Oromia Region",
    SIDAMA_REGION = "Sidama Region",
    SOMALI_REGION = "Somali Region",
    SOUTH_ETHIOPIA_REGION = "South Ethiopia Region",
    SOUTH_WEST_ETHIOPIA_PEOPLES_REGION = "South West Ethiopia Peoples Region",
    TIGRAY_REGION = "Tigray Region",
}

export class UserScoreTracker{
    previousScore: number = 0
    currentScore: number = 0
}